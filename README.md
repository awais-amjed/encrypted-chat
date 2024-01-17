<img style="height: 110px;" src="https://github.com/awais-amjed/encrypted-chat/assets/73714615/56e6e249-b179-4a40-b542-0a56fa12bda1" alt="Built with Appwrite" align="right"/>&nbsp;&nbsp;&nbsp;
<img style="height: 100px;" src="https://github.com/awais-amjed/encrypted-chat/assets/73714615/fa4e70f3-3927-4fea-9bfb-a087604f5ee6" alt="Built with Flutter" align="right"/>
<img style="height: 100px" src="https://user-images.githubusercontent.com/73714615/168187249-9a98411f-43d5-40d1-909d-0876352ab0dd.png" />

# Encrypted Chat


> Self Hosted End to End Encrypted Chat System

<br>
<br>
<p style="display: flex; align-items: start; gap: 10px">
  <img src="https://user-images.githubusercontent.com/73714615/168186996-b98e2c0f-7ed3-4f97-8ab1-f331e76b4ac7.png" width="13.5%" />
  <img src="https://user-images.githubusercontent.com/73714615/168187157-38f1efd8-03f3-4f96-b533-692baea4ec01.png" width="13.5%" />
  <img src="https://user-images.githubusercontent.com/73714615/168187162-a968c012-5e54-4aad-b979-5809a13dd206.png" width="13.5%" />
  <img src="https://user-images.githubusercontent.com/73714615/168187170-c3ade25e-be0b-4dfd-8878-ac170ad7bffd.png" width="13.5%" />
  <img src="https://user-images.githubusercontent.com/73714615/168187022-28bea1e7-a7b7-4854-b276-e459a83c4c6a.png" width="13.5%" />
  <img src="https://user-images.githubusercontent.com/73714615/168187177-b8498961-d363-4898-8d90-f421051fb118.png" width="13.5%" />
  <img src="https://user-images.githubusercontent.com/73714615/168187032-6b248e11-b876-46d3-a77a-e1eb302e37a3.png" width="13.5%" />
</p>

#
With the power of Flutter, Appwrite, and this app, you can easily host your Encrypted chat system in a few simple steps. No more fear of being snooped on, since you have all the control over your messages that are secured using a private key - and an even more awesome thing is that it's open-source so you can modify it to make it however you want it to be. The encryption is based on public-private key pairs where the private key is generated on the device and you can keep a backup of it using a QR code generated inside the app, which makes switching devices easy without data loss. The theme is based on Appwrite's website - and everything else is just CUTE AND SECURE.

# Top Features &nbsp; <img src="./resources/medal.png" height="30" align="justify"/>

- End To End Encrypted
- Self Hosted
- Private and Secure
- Realtime Chat and Notifications
- Beautiful Animations & avatars

## Getting Started &nbsp; <img src="./resources/run.png" height="30" align="justify"/>

To get a local copy up and running follow these steps.

# Setup Instructions &nbsp; <img src="./resources/computer.png" height="30" align="justify"/>

## Appwrite Installation
- Follow the steps mentioned on the official appwrite website for [instllation](https://appwrite.io/docs/installation) with docker
- In the directory where you ran the docker command, you will find a `.env` file
- Edit that file, find `_APP_FUNCTIONS_ENVS` and set it's value to `dart-2.16`
- Also delete the `_APP_FUNCTIONS_ENVS` field - Save the file
- In the same directory open a terminal or cmd and run the following command
```
docker-compose up -d
```
- This completes the docker setup

## Project Setup &nbsp; <img src="./resources/project_icon.png" height="30" align="justify"/>
- Open a browser and go to the `localhost:80` or if you set some other port
- Signup and remember the credentials - you will need them
- Create a new Project as shown below `Keep the project id as ecat` unless you want to rebuild your application.

![screenshot](./resources/project.png)

- Create an API Key with atleast these 12 permissions

![screenshot](./resources/api.png)

- Register Your Flutter Project `KEEP PACKAGE NAME AS IS` `coding.fries.ecat`

![screenshot](./resources/registration.png)

## Database and Functions &nbsp; <img src="./resources/database-storage.png" height="30" align="justify"/>

- Install the [appwrite cli](https://appwrite.io/docs/command-line)
- Open a directory and login to appwrite cli in a terminal or cmd
```
appwrite login
```
- Enter credentails used for signing up - Leave host as default unless you know what you are doing
- Download this script for [windows](./resources/create.cmd) or for [linux](./resources/create.sh)
- Run the script with following arguments
For Linux
```
./create.sh yourProjectID yourProjectName yourHost yourAPIKey
```
For Windows
```
./create.cmd yourProjectID yourProjectName yourHost yourAPIKey
```
- This will create an appwrte.json in your directory
- Now Download this [functions.zip](./resources/functions.zip) and extract in the same directory
- Run the follwing command
```
appwrite deploy --all
```
- Select all `a` and `enter` then again select all `a` and `enter`
- This will setup everything for you

# Known Bug &nbsp; <img src="./resources/bug.png" height="30" align="justify"/>

- The above command `appwrite deploy -all` might fail while deploying functions and give you an error `Unexpected token`
- If that's the case then you will have to create functions manually
- Open appwrite in browser `localhost:80` and go to functions
- You have to add three new functions with following ids:
```
1. createMessageCollection
2. createUserDocument
3. notifyUser
```
For all three of these you have to add these variables in the settings

![image](https://user-images.githubusercontent.com/73714615/168171851-8cce52fd-762c-4341-aa7e-53f48191c407.png)

For `createMessageCollection` and `notifyUser` add this in Execute access section:
```
role:member
```

![image](https://user-images.githubusercontent.com/73714615/168172099-7cd029af-2499-4f7a-bc77-750f3191e300.png)

and For `createUserDocument` check the account.create event

![image](https://user-images.githubusercontent.com/73714615/168172332-72fcf10d-4937-4320-bab4-a394051fe608.png)

- Now run these [commands](./resources/commands.txt) one by one in the same directory where you have the appwrite.json and functions
- After this all your functions will be deployed

## Usage &nbsp; <img src="./resources/smartphone.png" height="30" align="justify"/>

Download the apk, install and Open your app - Set your setup information by clicking the settings icon on the login screen - Enjoy free and private encrypted chat

# Future Improvements &nbsp; <img src="./resources/virtual-reality.png" height="30" align="justify"/>

- Multi Platform Support - especially Web
- Push Notifications implementation (when appwrite releases support or maybe using firebase)
- File Transfer - soon
- Message Data Persistance

## Authors &nbsp; <img src="./resources/poem.png" height="30" align="justify"/>

👤 **Awais Amjed**

- GitHub: [@Awais Amjed](https://github.com/awais-amjed)
- LinkedIn: [LinkedIn](https://www.linkedin.com/in/awais-amjed)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](../../issues/).

## Show your support &nbsp; <img src="./resources/support.png" height="30" align="justify"/>

Give a ⭐️ if you like this project!

## Acknowledgments &nbsp; <img src="./resources/medal.png" height="30" align="justify"/>

- FlatIcons - All images used are from [Flaticon](https://www.flaticon.com/) - Love their collections ❤️

## Attributions

- <a href="https://www.flaticon.com/free-icons/cat" title="cat icons">Cat icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/identity" title="identity icons">Identity icons created by srip - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/server" title="server icons">Server icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/user" title="user icons">User icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/access" title="access icons">Access icons created by Eucalyp - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/password" title="password icons">Password icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/feature" title="feature icons">Feature icons created by Flat Icons - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/computer" title="computer icons">Computer icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/run" title="run icons">Run icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/install" title="install icons">Install icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/project" title="project icons">Project icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/database" title="database icons">Database icons created by phatplus - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/bug" title="bug icons">Bug icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/app" title="app icons">App icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/vr" title="vr icons">Vr icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/poem" title="poem icons">Poem icons created by Smashicons - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/collaboration" title="collaboration icons">Collaboration icons created by Freepik - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/quality" title="quality icons">Quality icons created by Freepik - Flaticon</a>
