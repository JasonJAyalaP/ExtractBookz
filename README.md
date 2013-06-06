Have you foolishly archived your extensive and obviously legitimate ebook collection according to arcane scene rules? That is, a PDF/Epub/Mobi with a 8.3 filename inside multi-rars inside multi-zips inside a Dir-ect-tor-y? The cool kids tricked you with their ASCII art! I know. Me too. No worries though: I made a ruby script that extractz and renamez the bookz!

# Mac
* [Download the app zip](http://hub.darcs.net/JasonJAyalaP/ExtractBookz/raw/ExtractBookz.app.zip) and double click to extract.
* Open ExtractBookz.app and drag your book folder, or a folder of book folders, onto the window. The books will be extracted into that same folder.

# Windows
* No GUI yet, so you'll need to run the script via the commandline
* [Download the zip](http://hub.darcs.net/JasonJAyalaP/ExtractBookz/raw/ExtractBookz.zip) and extract.
* [Download ruby](http://rubyforge.org/frs/download.php/76804/rubyinstaller-2.0.0-p0.exe) and install. Make sure to check "Add Ruby executables to your PATH".
* See "Commandline Usage" below

# Linux
* You'll need unrar and unzip in your path or ExtractBookz.rb directory
* As well as Ruby
* See "Commandline Usage" and tell me how it goes!

# Commandline Usage
Open your terminal/command prompt, navigate to the directory where you extracted ExtractBookz.rb, and type:

	ruby ExtractBookz.rb "source" "target"

Source can either be a single directory like "~/My.Publisher.-.My.Crazy.Book.2011.ebook-DiGiBook/", or a folder that contains a bunch of those directories. ExtractBookz cleans up after itself, and won't delete or change the original directories. Target is where the bookz will go. If left blank, target will be the same folder as "source".

# TODO
* Alfred 2 workflow
* More error handling just cuz in case.
* Windows GUI
* iOS App to extractz on the go, $0.99
