<h1 align="center"> A minimal powershell script to assist in moving applications between multiple screens. </h1>

<p align="center">
<a href="#key-features"> Key Features</a>*
<a href="#how-to-use"> How to Use</a>*
<a href="#how-to-run"> How to Run </a>*
<a href="#credits"> Credits</a>*
<a href="#warning"> Credits</a>*
<a href="#license"> License</a>*
</p>

## Key Features
* Moving windows between left and right displays
* Moving windows between the top and bottom displays
* Centering an app horizontally

## How To Use
Simply pick the application you wish to move from the list and press the button labeled with the location you wish to move it to. 

## How to Run 
To run this application, you will need to download the directory and unpack it at a persistent location. Once the two files have been unpacked open main.ps1 and modyfy the path in line nr.17, launch Task Scheduler (taskschd.msc) and configure a new task executing 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden  -Command "[#PATH TO C:/main.ps1#]"'  to run on startup with admin privileges.

> **Note**
>Admin privileges are required to read the screen rotation from the registry as well as move elevated apps. 

## Warning 
This is my first major powershell script, so the code might not be the best. If you see a problem with it, please feel free to create an issue. My main goal with this project was functionality, and from my testing, it is functional, so I am happy with what I created. 

## Credits
Thank you to the [WOA Project](https://github.com/WOA-Project) for porting windows to the Surface Duo

As well as [Boe Prox](https://github.com/proxb) for making the Set-Window powershell module

## License
MIT
