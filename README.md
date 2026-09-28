# Windows Power Plan Manager (Balanced / Gaming / Battery Saver)

An optimized Windows 10/11 batch script that creates 3 specialized power plans via `powercfg` and automatically generates desktop shortcuts for one-click switching.

[🇹🇷 Türkçe Açıklama İçin Aşağı Kaydırın / Scroll down for Turkish](#-türkçe-açıklama)

---

## ⚡ Power Profiles

* **🍃 Balanced Mode (Silent & Cool):** Disables CPU Turbo Boost and tunes the Energy Performance Preference (EPP) to 60. Prevents sudden frequency spikes (4.0+ GHz) during basic tasks, streaming, or browsing, keeping fans silent and chassis cool.
* **🎮 Gaming Mode (Maximum Performance):** Unleashes full CPU potential with aggressive boost, resets EPP to 0, and keeps all cores unparked. Ideal for demanding games and heavy workloads (fan noise and heat will naturally increase).
* **🔋 Battery Saver Mode (Max Efficiency):** Enforces passive cooling, aggressive hardware sleep states (ASPM, USB selective suspend), and sets display brightness to 40% to maximize battery runtime.

---

## 💻 Tested Hardware & Environment

* **OS:** Windows 11 Home / Pro (x64)
* **CPU:** Intel Core i5-13420H (Hybrid Architecture: P-Cores / E-Cores)
* **GPU:** NVIDIA GeForce RTX 4050 Laptop GPU

> **Note:** Works with most modern Intel and AMD systems through standard Windows `powercfg` APIs. Hardware-level policies (such as PCIe ASPM or cooling modes) may vary based on motherboard BIOS support. Unsupported optional settings are safely skipped without affecting stability.

---

## 🚀 Installation & Usage

1. Download `GucKurulum.bat`.
2. Right-click and select **"Run as Administrator"** (required for writing power schemes).
3. The script will configure the profiles and place shortcuts for **Denge** (Balanced), **Oyun** (Gaming), and **Pil** (Battery) directly on your Desktop.
4. Double-click any desktop shortcut to switch modes instantly.

---

## 🔍 Diagnostics

Upon execution, a diagnostic log named **`guc-planlari-rapor.txt`** is generated in the script's directory. If you run into issues, inspect this file or attach it when opening an Issue.

---

## ⚠️ Disclaimer

This tool does not promise guaranteed FPS gains or stutter fixes; it optimizes how Windows handles CPU frequency scaling and power distribution. Use at your own risk.

---

<br>

# 🇹🇷 Türkçe Açıklama

Windows 10 ve 11 için optimize edilmiş, tek tıkla masaüstüne kısayol atayan ve `powercfg` altyapısını kullanan güç yönetimi betiği.

## ⚡ Güç Profilleri

* **🍃 Denge Modu (Sessiz & Serin):** Turbo Boost kapatılır ve EPP değeri 60'a dengelenir. Günlük işlerde, internette gezinirken veya video izlerken işlemcinin anlık 4.0+ GHz hızlara fırlayıp gereksiz ısınmasını ve fan açmasını engeller.
* **🎮 Oyun Modu (Maksimum Performans):** Turbo Boost tam kapasite açılır, EPP sıfırlanır ve tüm çekirdekler aktif tutulur. Donanımın tam performansını kullanması sağlanır (artan frekans ve voltaj nedeniyle fan sesi ve sıcaklık artışı doğaldır).
* **🔋 Pil Modu (Maksimum Tasarruf):** Pasif soğutma politikası devreye girer, USB ve PCIe cihazları derin uykuya alınır ve ekran parlaklığı optimize edilerek batarya ömrü korunur.

## 🚀 Kurulum

1. `GucKurulum.bat` dosyasını indirin.
2. Dosyaya sağ tıklayıp **"Yönetici Olarak Çalıştır"** seçeneğini seçin.
3. Masaüstüne gelen **Denge**, **Oyun** veya **Pil** kısayollarına çift tıklayarak anında geçiş yapın.
