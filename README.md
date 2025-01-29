# Mass Message Sender for Telegram, Discord, and WhatsApp

An AutoHotkey (v2) script to automate sending predefined messages to contacts on your favourite messaging apps. Designed for bulk greetings or reminders. Modify the "Sleep" delays based on your system response time.

---

## Features

- **Predefined Messages**: Send holiday greetings, daily messages, or tests.
- **Contact Management**: Uses `.txt` files to track contacts and mark completed sends.
- **Hotkeys**: 
  - `F7`: Pause/stop the script.
  - `F8`: Force quit the program.
- **Progress Tracking**: Contacts are marked with `?` after processing.
- **GUI Interface**: Simple dropdown menu to select messages.

---

## Installation

1. **Install AutoHotkey v2**:  
   Download from [AutoHotkey v2](https://www.autohotkey.com/v2/) and install.

2. **Download Script**:  
   - Clone this repo or download [`telegram-sender.ahk`](/telegram/telegram-sender.ahk), [`discord-sender.ahk`](/discord/discord-sender.ahk), or [`whatsapp-sender.ahk`](/whatsapp/whatsapp-sender.ahk).

3. **Prepare Files**:  
   - Create `people.txt` in the script folder (one contact per line).
   - For each message option (e.g., `NewYear`, `Xmas`), create a `<key>-people.txt` file (e.g., `NewYear-people.txt`).
   - To make it easier, the files will be created for you if you're running the script for the first time.

---

## Usage

1. **Run the Script**:  
   Double-click `telegram-sender.ahk`, `discord-sender.ahk`, or `whatsapp-sender.ahk`.

2. **Select a Message**:  
   Choose a message from the dropdown and click "OK".

3. **Let It Run**:  
   - Ensure the respective messaging app is open and logged in.
   - The script will:
     1. Search for each contact.
     2. Send the message.
     3. Mark contacts as processed with `?`.

---

## Future Development

### Multi-Platform Integration
- **Better Tracking**:  
  A better way to make sure that the messages that are not actually sent to the people are correctly marked.
- **Unified Configuration**:  
  A central `config.ini` file to manage platforms, messages, and contacts.
- **Enhanced UI**:  
  Tabs/platform selector and progress bars.

### Planned Features
- **Scheduled Sending**: Send messages at specific times.
- **Attachment Support**: Include images/docs with messages.
- **Error Recovery**: Resume interrupted sessions.

---

## How to Contribute

1. **Report Issues**:  
   Open a GitHub issue for bugs or feature requests,
Or [email me](mailto:augy@augystudios.com?subject=Report%20Issues).

2. **Submit Pull Requests**:  
   Fork the repo, make changes, and submit a PR.

3. **Suggest Improvements**:  
   Share ideas for UI/UX or new platforms,  
   Or [email me](mailto:augy@augystudios.com?subject=Improvement%20Suggestions).

4. Check out my other projects on [my website](https://augystudios.com/).

---

## Notes

- **Dependencies**:  
  - Telegram must be installed and running.
  - Contacts must match **exactly** with Telegram usernames/phone numbers.

- **File Structure**:
```
telegram/
├── telegram-sender.ahk
├── people.txt
├── NewYear-people.txt
├── CNY-people.txt
├── Morning-people.txt
├── Xmas-people.txt
├── Test-people.txt
└── instructions.txt (auto-generated)
discord/
├── discord-sender.ahk
├── people.txt
├── NewYear-people.txt
├── CNY-people.txt
├── Morning-people.txt
├── Xmas-people.txt
├── Test-people.txt
└── instructions.txt (auto-generated)
whatsapp/
├── whatsapp-sender.ahk
├── people.txt
├── NewYear-people.txt
├── CNY-people.txt
├── Morning-people.txt
├── Xmas-people.txt
├── Test-people.txt
└── instructions.txt (auto-generated)
```

---

## License

MIT License. See [LICENSE](LICENSE) for details.