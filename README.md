# MakingSenseOfUniSens 🎛️✂️
Welcome to MakingSenseOfUniSens — your friendly MATLAB GUI tool to easily crop UniSens datasets by specifying start and end times! Perfect for trimming down large sensor data collections and their linked CSV files, all without hassle.


Features ✨
Intuitive GUI to select your UniSens dataset folder

Set start and end times in seconds for precise cropping

Automatically detects the dataset's sampling rate

Crops UniSens signals and associated CSV files (nn_live.csv, bpmbxb_live.csv) within your specified time window

Creates a new output folder with your trimmed dataset

Real-time status updates and helpful error messages


How to Use 🚀
Run makingsenseofunisens in MATLAB to launch the GUI.

Click Durchsuchen to select your UniSens input folder.

Enter the Startzeit and Endzeit (in seconds) to define your crop interval.

Provide a name for your output folder in Name Ausgabeordner.

Click Dataset zuschneiden and watch the magic happen! Your cropped dataset and CSV files will be saved to the output folder.

Requirements 📦
MATLAB with Java support enabled

Unisens-2.3.0.jar placed in the same directory as the script

Your UniSens dataset folder ready to crop

unisensCrop function accessible in your MATLAB path


Notes 📝
The tool looks for CSV files named nn_live.csv and bpmbxb_live.csv inside your input folder (semicolon-separated values).

If CSV timestamps are in milliseconds, they’ll automatically be converted to seconds for accurate cropping.

If the output folder already exists, you'll be asked if you want to overwrite it.


Troubleshooting ⚠️
Missing JAR file? Ensure Unisens-2.3.0.jar is in the same folder as this script.

Sampling rate errors? Make sure your UniSens dataset includes valid signal entries.

CSV file issues? Verify the CSV files exist and contain timestamps within your chosen interval.


## License

This project is licensed under the MIT License — see the LICENSE file for details. Please credit me as the author if you use this tool.



