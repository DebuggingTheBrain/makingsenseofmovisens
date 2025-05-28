function unisens_crop_gui
    % Fügt Unisens-JAR zum Java-Pfad hinzu (wenn noch nicht geladen)
    addUnisensJar();

    % GUI-Fenster
    fig = figure('Name', 'UniSens Crop Tool', 'Position', [300 300 520 320]);

    % Eingabeordner
    uicontrol('Style', 'text', 'Position', [20 270 150 20], 'String', 'UniSens Eingabeordner:');
    folderEdit = uicontrol('Style', 'edit', 'Position', [180 270 240 25]);
    uicontrol('Style', 'pushbutton', 'Position', [430 270 80 25], 'String', 'Durchsuchen', ...
              'Callback', @(src,event) selectFolder(folderEdit));

    % Startzeit in Sekunden
    uicontrol('Style', 'text', 'Position', [20 220 150 20], 'String', 'Startzeit (Sekunden):');
    startEdit = uicontrol('Style', 'edit', 'Position', [180 220 100 25], 'String', '0');

    % Endzeit in Sekunden
    uicontrol('Style', 'text', 'Position', [20 180 150 20], 'String', 'Endzeit (Sekunden):');
    endEdit = uicontrol('Style', 'edit', 'Position', [180 180 100 25], 'String', '');

    % Ausgabeordnername
    uicontrol('Style', 'text', 'Position', [20 140 150 20], 'String', 'Name Ausgabeordner:');
    outNameEdit = uicontrol('Style', 'edit', 'Position', [180 140 240 25]);

    % Statusanzeige
    statusText = uicontrol('Style', 'text', 'Position', [20 100 490 25], 'String', '');

    % Button
    uicontrol('Style', 'pushbutton', 'Position', [180 50 180 40], 'String', 'Dataset zuschneiden', ...
              'FontSize', 12, 'Callback', @cropCallback);

    % --- Funktionen ---
    function addUnisensJar()
        %ADDUNISENSJAR Fügt unisens.jar zum dynamischen Java-Pfad hinzu
        version = '2.3.0';
        unisensJar = ['Unisens-' version '.jar'];
        dPath = javaclasspath('-dynamic');
        for i = 1:length(dPath)
            [~, name, ext] = fileparts(dPath{i});
            if strcmp([name ext], unisensJar)
                return; % Jar ist schon geladen
            end
        end
        [currentPath, ~, ~] = fileparts(mfilename('fullpath'));
        jarFullPath = fullfile(currentPath, unisensJar);
        if ~exist(jarFullPath, 'file')
            error(['Die Datei ' unisensJar ' wurde im Skriptordner nicht gefunden!']);
        end
        javaaddpath(jarFullPath);
    end

    function selectFolder(editHandle)
        folder = uigetdir;
        if folder ~= 0
            set(editHandle, 'String', folder);
        end
    end

    function cropCallback(~, ~)
        set(statusText, 'String', 'Arbeite...');
        drawnow;

        inFolder = get(folderEdit, 'String');
        startSec = str2double(get(startEdit, 'String'));
        endSec = str2double(get(endEdit, 'String'));
        outName = get(outNameEdit, 'String');

        % Validierung
        if isempty(inFolder) || ~isfolder(inFolder)
            errordlg('Bitte gültigen Eingabeordner angeben.', 'Fehler');
            set(statusText, 'String', '');
            return;
        end
        if isnan(startSec) || isnan(endSec) || startSec < 0 || endSec <= startSec
            errordlg('Bitte Start- und Endzeit korrekt eingeben (Endzeit > Startzeit).', 'Fehler');
            set(statusText, 'String', '');
            return;
        end
        if isempty(outName)
            errordlg('Bitte einen Namen für den Ausgabeordner eingeben.', 'Fehler');
            set(statusText, 'String', '');
            return;
        end

        % Ausgabeordner
        parentPath = fileparts(inFolder);
        outFolder = fullfile(parentPath, outName);

        if exist(outFolder, 'dir')
            choice = questdlg('Ausgabeordner existiert bereits. Überschreiben?', 'Ordner existiert', 'Ja', 'Nein', 'Nein');
            if ~strcmp(choice, 'Ja')
                set(statusText, 'String', 'Abgebrochen.');
                return;
            else
                rmdir(outFolder, 's');
            end
        end

        % Abtastrate ermitteln
        try
            j_unisensFactory = org.unisens.UnisensFactoryBuilder.createFactory();
            j_unisens = j_unisensFactory.createUnisens(inFolder);
            j_entries = j_unisens.getEntries();
            crop_samplerate = [];
            nEntries = j_entries.size();
            for i = 0:nEntries-1
                j_entry = j_entries.get(i);
                entry_class_name = char(j_entry.getClass.toString);
                if strcmp(entry_class_name, 'class org.unisens.ri.SignalEntryImpl')
                    crop_samplerate = j_entry.getSampleRate();
                    break;
                end
            end
            if isempty(crop_samplerate)
                error('Keine SignalEntry mit Abtastrate gefunden.');
            end
            j_unisens.closeAll();
        catch ME
            errordlg(['Fehler beim Lesen der Abtastrate: ' ME.message], 'Fehler');
            set(statusText, 'String', '');
            return;
        end

        % Zeiten in Samples umrechnen
        start_sample = floor(startSec * crop_samplerate);
        end_sample = ceil(endSec * crop_samplerate);

        try
            % Aufruf des zugeschnittenen Skripts (unisenCrop)
            unisensCrop(inFolder, outFolder, crop_samplerate, start_sample, end_sample);
            
            % --- CSV Dateien zuschneiden ---
            csvFiles = {'nn_live.csv', 'bpmbxb_live.csv'}; % korrigierte Dateinamen
            for i = 1:length(csvFiles)
                csvFile = fullfile(inFolder, csvFiles{i});
                if ~exist(csvFile, 'file')
                    fprintf('⚠️ CSV-Datei nicht gefunden: %s\n', csvFile);
                    continue;
                end
                % CSV einlesen mit Semikolon-Trennung
                data = readtable(csvFile, 'Delimiter', ';');
                
                % Erste Spalte als Zeit
                timeColumn = data{:,1};
                
                % Falls Zeit in ms angegeben, in Sekunden konvertieren
                if max(timeColumn) > 1e6
                    timeColumn = timeColumn / 1000;
                end
                
                % Filter-Maske für Zeitintervall
                mask = timeColumn >= startSec & timeColumn <= endSec;
                
                cutData = data(mask,:);
                
                if isempty(cutData)
                    fprintf('⚠️ Keine Daten im Zeitbereich für Datei: %s\n', csvFiles{i});
                    continue;
                end
                
                % Gefilterte CSV in Ausgabeordner speichern
                writetable(cutData, fullfile(outFolder, csvFiles{i}), 'Delimiter', ';');
                fprintf('✔️ %s erfolgreich zugeschnitten.\n', csvFiles{i});
            end

            set(statusText, 'String', ['Erfolg! Daten gespeichert in: ' outFolder]);
        catch ME
            errordlg(['Fehler beim Zuschneiden: ' ME.message], 'Fehler');
            set(statusText, 'String', '');
        end
    end
end
