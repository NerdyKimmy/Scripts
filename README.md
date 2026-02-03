# Unix System Automation & POSIX Utilities

A collection of lightweight, portable, and efficient scripts designed for daily system automation and environment management. This repository focuses on the **Unix Way**: building small, modular tools that communicate effectively via pipes and signals.

> **Environment Note:** Developed and optimized for **Void Linux** (runit) and **FreeBSD**.

---

## 🛠 Tech Stack

* **Shell:** `dash` (POSIX compliant), `sh`, Bash.
* **Python:** 3.x (with `requests` for API integration).
* **IPC & Synchronization:** Named pipes (FIFOs), signal trapping, and subshell concurrency.
* **System Integration:** `dbus-send` (for power management), `pactl` (event-based audio monitoring), `xsetroot`.
* **Core Utilities:** `awk`, `sed`, `grep`, `stdbuf`, `playerctl`.

---

## 📂 Featured Scripts

| Script | Language | Description | Technical Highlight |
| :--- | :--- | :--- | :--- |
| **`bar.sh`** | `dash` | Asynchronous DWM status bar manager. | **FIFO Architecture:** Uses a named pipe in `/tmp/` to aggregate data from parallel background processes. |
| **`weather.py`** | Python | Weather fetcher via OpenWeatherMap API. | **Smart Caching:** Implements a local JSON cache (`~/.cache/`) with a 600s TTL to prevent redundant API calls. |
| **`blue.sh`** | `sh` | Bluetooth device monitoring. | Real-time event parsing using `btmon` and `awk` filters. |
| **`powermenu.sh`**| `sh` | Power management menu. | Interacts with system buses via `dbus-send` for Shutdown/Reboot actions. |
| **`lock.sh`** | `sh` | Screen locker utility. | Handles secure session state before invoking the locker. |
| **`waldwm.sh`** | `sh` | Wallpaper & Theme manager. | Updates WM colors and backgrounds dynamically. |

---

## 🚀 Architectural Deep Dive

### 1. Event-Driven Status Bar (`bar.sh`)
Unlike standard polling bars, `bar.sh` utilizes an **asynchronous FIFO-based model**:
* **Instant Updates:** Volume and Keyboard layout changes are reflected immediately. Keyboard polling runs at a high frequency (0.1s), while Volume updates are triggered by `pactl subscribe` events.
* **Resource Management:** Power-intensive tasks (Battery/Date) update on a slow 60-second timer to minimize CPU wakeups.
* **Concurrency:** Multiple independent subshells write to a shared FIFO, which is then read by a single loop to update the root window name.

### 2. Efficient Data Fetching (`weather.py`)
To ensure a responsive UI and respect API limits:
* **Local Persistence:** Data is cached in `~/.cache/weather_cache.json`.
* **Icon Mapping:** Maps OpenWeatherMap codes to Nerd Font glyphs for aesthetic CLI/Status-bar integration.
* **Fallback Logic:** Displays a graceful placeholder if the network is unreachable or the API limit is reached.

---

## ⚙️ Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
    ```
2.  **Dependencies:**
    * **Linux/BSD:** `dash`, `pactl`, `playerctl`, `xset`, `xsetroot`.
    * **Python:** `pip install requests`.
3.  **Usage:**
    Add the scripts to your `$PATH` or call them directly. For the status bar:
    ```bash
    ./bar.sh &
    ```

---

I am Unix enthusiast dedicated to building minimal, fast, and secure systems. Expert in navigating the nuances of **FreeBSD** and **Void Linux**, with a focus on POSIX-compliant automation and system-level scripting.
