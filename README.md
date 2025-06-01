## 🛡️ Şifre Yöneticisi (Ruby ile)

Bu proje, Ruby dilinde yazılmış basit ama güçlü bir **şifre yöneticisidir**. Şifrelerinizi güvenli bir şekilde saklar, şifreleme yapar, otomatik güçlü şifreler üretir ve gizli bir ana şifre ile giriş sağlar.

---

### 📦 Özellikler

* 🔑 Ana şifre ile koruma
* 🔐 AES-256 şifreleme
* ✍️ Manuel ya da otomatik şifre girişi
* 🧠 Popüler hizmetler için hazır seçenekler (Gmail, e-Devlet, Instagram vb.)
* 🖎️ Şifre görüntüleme
* 🗑️ Şifre silme
* 🖥️ `.bat` dosyası ile kolay çalıştırma

---

### ⚙️ Kurulum

> **Not:** Ruby 3.0+ sisteminizde kurulu olmalıdır.
> İndirmek için: [https://rubyinstaller.org/](https://rubyinstaller.org/)

1. Gerekli Ruby gem'lerini yükleyin:

```bash
gem install tty-prompt
```

2. Bu dosyaları aynı klasöre koyun:

```
📁 password-manager/
 ├️ 📄 manager.rb      # Ana Ruby dosyası
 ├️ 📄 passwords.json  # Şifre veri tabanı (otomatik oluşur)
 ├️ 📄 master.hash     # Ana şifre dosyası (ilk kullanımda oluşur)
 └️ 📄 çalıştır.bat    # (İsteğe bağlı) Kolay başlatma için bat dosyası
```

3. Uygulamayı başlatmak için:

```bash
ruby manager.rb
```

> veya `.bat` dosyasıyla:

```bat
@echo off
ruby manager.rb
pause
```

---

### 🔐 Kullanım

* İlk açılışta sizden bir **ana şifre** belirlemeniz istenir.
* Sonraki girişlerde bu şifre ile doğrulama yapılır.
* Uygulama üzerinden:

  * Şifre ekleyebilir,
  * Kayıtlı şifreleri görüntüleyebilir,
  * İstenilen şifreyi silebilirsiniz.

---

### 📃 Dosya Açıklamaları

| Dosya            | Açıklama                                         |
| ---------------- | ------------------------------------------------ |
| `manager.rb`     | Uygulamanın ana kodu                             |
| `passwords.json` | Şifrelerin şifreli olarak tutulduğu dosya        |
| `master.hash`    | Ana şifrenin SHA256 hash olarak saklandığı dosya |
| `çalıştır.bat`   | Windows için çalıştırma kolaylığı sağlar         |

---

### 🧍️ İpuçları

* Şifre dosyalarını güvenli bir klasörde tutun.
* `passwords.json` içeriği şifrelenmiştir ama yedek alınabilir.
* Ana şifreyi unutursanız, `master.hash` dosyasını silerek sıfırdan ayarlayabilirsiniz (var olan şifrelere erişilemez).

---

### 📃 Lisans

MIT Lisansı © 2025

---
