require 'json'
require 'openssl'
require 'base64'
require 'tty-prompt'
require 'securerandom'
require 'digest'

DB_FILE = 'passwords.json'
MASTER_HASH_FILE = 'master.hash'
prompt = TTY::Prompt.new


def save_master_hash(master_password)
  hash = Digest::SHA256.hexdigest(master_password)
  File.write(MASTER_HASH_FILE, hash)
end


def verify_master_password(input)
  return false unless File.exist?(MASTER_HASH_FILE)
  stored_hash = File.read(MASTER_HASH_FILE).strip
  input_hash = Digest::SHA256.hexdigest(input)
  stored_hash == input_hash
end

def encrypt(password, key)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = Digest::SHA256.digest(key)
  iv = cipher.random_iv
  cipher.iv = iv
  encrypted = cipher.update(password) + cipher.final
  Base64.strict_encode64(iv + encrypted)
end

def decrypt(encrypted_data, key)
  decoded = Base64.decode64(encrypted_data)
  iv = decoded[0..15]
  encrypted = decoded[16..-1]
  decipher = OpenSSL::Cipher.new('AES-256-CBC')
  decipher.decrypt
  decipher.key = Digest::SHA256.digest(key)
  decipher.iv = iv
  decipher.update(encrypted) + decipher.final
end

def load_passwords
  File.exist?(DB_FILE) ? JSON.parse(File.read(DB_FILE)) : {}
end

def save_passwords(passwords)
  File.write(DB_FILE, JSON.pretty_generate(passwords))
end

def menu(prompt, key)
  passwords = load_passwords

  loop do
    choice = prompt.select("Ne yapmak istersin?", cycle: true) do |menu|
      menu.choice '🔐 Şifre Ekle', :add
      menu.choice '🔎 Şifre Göster', :show
      menu.choice '🗑️ Şifre Sil', :delete
      menu.choice '❌ Çıkış', :exit
    end

    case choice
    when :add
      service = prompt.select("Hangi hizmet için şifre ekleyeceksin?") do |m|
        m.choice "📧 Gmail", "Gmail"
        m.choice "🟣 Instagram", "Instagram"
        m.choice "🇹🇷 e-Devlet", "e-Devlet"
        m.choice "📘 Facebook", "Facebook"
        m.choice "📦 Amazon", "Amazon"
        m.choice "➕ Başka bir hizmet yaz", :manual
      end

      if service == :manual
        service = prompt.ask("Hizmet adı nedir?")
      end

      generate_auto = prompt.select("Şifreyi nasıl girmek istersin?") do |m|
        m.choice "🧠 Kendim gireceğim", :manual
        m.choice "⚙️ Otomatik güçlü şifre üret", :auto
      end

      password =
        if generate_auto == :manual
          prompt.mask("Şifre nedir?")
        else
          length = prompt.ask("Kaç karakterlik bir şifre olsun?", default: "16").to_i
          charset = [('a'..'z'), ('A'..'Z'), ('0'..'9'), ['!', '@', '#', '$', '%', '&', '*']].map(&:to_a).flatten
          generated = Array.new(length) { charset.sample(random: SecureRandom) }.join
          prompt.ok("🔐 Üretilen Şifre: #{generated}")
          generated
        end

      passwords[service] = encrypt(password, key)
      save_passwords(passwords)
      prompt.ok("✔️ Kaydedildi.")

    when :show
      if passwords.empty?
        prompt.warn("Hiçbir şifre kaydedilmemiş.")
      else
        service = prompt.select("Hangi hizmetin şifresini görmek istersin?", passwords.keys)
        encrypted = passwords[service]
        decrypted = decrypt(encrypted, key)
        prompt.ok("🔑 #{service} için şifre: #{decrypted}")
      end

    when :delete
      if passwords.empty?
        prompt.warn("Henüz kayıtlı şifre yok.")
      else
        service = prompt.select("Hangi servisin şifresi silinsin?", passwords.keys)
        confirm = prompt.yes?("Emin misin? '#{service}' şifresi silinecek.")
        if confirm
          passwords.delete(service)
          save_passwords(passwords)
          prompt.ok("✔️ '#{service}' silindi.")
        else
          prompt.say("İşlem iptal edildi.")
        end
      end

    when :exit
      prompt.ok("Görüşmek üzere!")
      break
    end
  end
end

if !File.exist?(MASTER_HASH_FILE)
  prompt.warn("Bu ilk girişiniz. Bir ana şifre belirleyin.")
  new_master = prompt.mask("Yeni Ana Şifre:")
  confirm = prompt.mask("Tekrar:")
  if new_master == confirm
    save_master_hash(new_master)
    prompt.ok("✔️ Ana şifre kaydedildi.")
    menu(prompt, new_master)
  else
    prompt.error("❌ Şifreler uyuşmadı.")
  end
else
  entered = prompt.mask("🔑 Ana şifrenizi girin:")
  if verify_master_password(entered)
    prompt.ok("✔️ Giriş başarılı.")
    menu(prompt, entered)
  else
    prompt.error("❌ Hatalı şifre. Program kapatılıyor.")
  end
end
