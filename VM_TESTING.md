# 🖥️ Guía de Testing en Máquinas Virtuales

Esta guía proporciona instrucciones paso a paso para probar Dreamcoder Dotfiles en una máquina virtual limpia de Arch Linux.

---

## 📋 Requisitos Previos

### Software Necesario
- **VirtualBox** o **VMware** o **QEMU/KVM**
- **Arch Linux ISO** (descarga desde https://archlinux.org/download/)
- **Conexión a Internet** estable

### Especificaciones Mínimas de VM
- **RAM:** 2GB (recomendado 4GB)
- **Disco:** 20GB
- **CPU:** 2 cores
- **Red:** NAT o Bridged (con acceso a internet)

---

## 🚀 Instalación Base de Arch Linux en VM

### 1. Crear la Máquina Virtual

```bash
# VirtualBox
VBoxManage createvm --name "ArchTest-Dreamcoder" --ostype "ArchLinux_64" --register
VBoxManage modifyvm "ArchTest-Dreamcoder" --memory 4096 --cpus 2
VBoxManage createhd --filename ~/VMs/ArchTest.vdi --size 20480
VBoxManage storagectl "ArchTest-Dreamcoder" --name "SATA Controller" --add sata
VBoxManage storageattach "ArchTest-Dreamcoder" --storagectl "SATA Controller" \
  --port 0 --device 0 --type hdd --medium ~/VMs/ArchTest.vdi
```

### 2. Instalación Base (Dentro de la VM)

```bash
# 1. Configurar teclado (opcional, solo si no usas US)
loadkeys es  # o tu layout

# 2. Conectar a internet
# Para WiFi:
iwctl
station wlan0 connect NOMBRE_RED
exit

# Para Ethernet (usualmente automático):
ping -c 3 archlinux.org

# 3. Particionar disco
cfdisk /dev/sda
# Crear:
# - /dev/sda1: 512M (tipo EFI System) para UEFI
# - /dev/sda2: resto (tipo Linux filesystem)

# 4. Formatear particiones
mkfs.fat -F32 /dev/sda1  # Para UEFI
mkfs.ext4 /dev/sda2

# 5. Montar particiones
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# 6. Instalar sistema base
pacstrap /mnt base linux linux-firmware base-devel sudo vim networkmanager

# 7. Generar fstab
genfstab -U /mnt >> /mnt/etc/fstab

# 8. Entrar al sistema
arch-chroot /mnt

# 9. Configurar sistema
ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
hwclock --systohc

# Editar /etc/locale.gen y descomentar:
# en_US.UTF-8 UTF-8
# es_ES.UTF-8 UTF-8 (opcional)
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# 10. Configurar hostname
echo "archtest" > /etc/hostname

# 11. Configurar red
cat > /etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   archtest.localdomain archtest
EOF

# 12. Configurar contraseña de root
passwd

# 13. Crear usuario de prueba
useradd -m -G wheel -s /bin/bash testuser
passwd testuser

# 14. Configurar sudo
EDITOR=vim visudo
# Descomentar: %wheel ALL=(ALL:ALL) ALL

# 15. Instalar bootloader
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# 16. Habilitar NetworkManager
systemctl enable NetworkManager

# 17. Salir y reiniciar
exit
umount -R /mnt
reboot
```

---

## ✅ Testing de Dreamcoder Dotfiles

### Fase 1: Preparación (Después del primer boot)

```bash
# 1. Login como testuser
# Usuario: testuser
# Password: [tu contraseña]

# 2. Verificar internet
ping -c 3 google.com

# 3. Actualizar sistema
sudo pacman -Syu

# 4. Instalar git (mínimo necesario)
sudo pacman -S git
```

### Fase 2: Instalación de Dotfiles

```bash
# 1. Clonar repositorio
cd ~
git clone https://github.com/Albert-fer02/Dreamcoder_dots.git
cd Dreamcoder_dots

# 2. Ver opciones disponibles
./install.sh help

# 3. OPCIÓN A: Instalación completa (recomendada)
./install.sh

# 3. OPCIÓN B: Instalación manual por pasos
# Primero instalar paquetes manualmente
sudo pacman -S --needed zsh git curl wget kitty fastfetch nano starship \
  zsh-autosuggestions zsh-syntax-highlighting fzf bat eza fd ripgrep \
  zoxide tmux github-cli jq stow pass btop

# Luego solo configs
./install.sh --skip-packages

# 4. Verificar instalación
./verify.sh
```

### Fase 3: Verificación Manual

```bash
# 1. Reiniciar terminal o recargar
source ~/.zshrc

# 2. Verificar herramientas
command -v fzf zoxide bat eza fd rg gh jq stow pass btop tmux

# 3. Probar FZF
# Presiona Ctrl+T (debería aparecer selector de archivos)
# Presiona Ctrl+R (debería aparecer búsqueda en historial)

# 4. Probar Zoxide
cd ~/Documents  # o cualquier directorio
z Doc           # debería autocompletar a Documents

# 5. Probar Bat
bat ~/.zshrc    # debería mostrar con syntax highlighting

# 6. Probar Eza
ls              # debería mostrar con iconos
ll              # lista larga con iconos

# 7. Probar Tmux
tmux
# Presiona Ctrl+a | (split vertical)
# Presiona Ctrl+a - (split horizontal)
# Presiona Alt+Arrows (navegar entre paneles)
# Presiona Ctrl+a d (detach)

# 8. Probar Ripgrep
rg "export" ~/.zshrc

# 9. Probar fd
fd "zshrc" ~

# 10. Verificar PowerLevel10k
# El prompt debería verse colorido con iconos

# 11. Probar aliases
c              # clear
ll             # lista con iconos
..             # cd ..
gs             # git status -s
```

### Fase 4: Testing de Portabilidad

```bash
# Verificar que no hay username hardcoded
grep -r "dreamcoder08" ~/.zshrc ~/.bashrc ~/.tmux.conf

# Verificar EDITOR
echo $EDITOR
which $EDITOR

# Verificar PATH
echo $PATH | tr ':' '\n'

# Verificar PNPM_HOME
echo $PNPM_HOME

# Verificar PROJECTS_DIR
echo $PROJECTS_DIR

# Verificar nano backups directory
ls -la ~/.nano/backups/

# Verificar que kitty no tiene errores
kitty --version
# Abrir kitty y verificar que no hay warnings sobre ml4w
```

---

## 🐛 Problemas Comunes y Soluciones

### Problema 1: "Git no está instalado"
```bash
# Solución
sudo pacman -S git
```

### Problema 2: "chsh: PAM: Authentication failure"
```bash
# Solución: cambiar shell manualmente
sudo chsh -s /usr/bin/zsh testuser
# O editar /etc/passwd directamente
sudo vim /etc/passwd
# Cambiar /bin/bash por /usr/bin/zsh en la línea de testuser
```

### Problema 3: "Kitty muestra warning sobre ml4w"
```bash
# Verificar que el include esté comentado
grep "ml4w" ~/.config/kitty/kitty.conf
# Debería estar comentado con #
```

### Problema 4: "PowerLevel10k no se ve bien"
```bash
# Instalar Nerd Fonts
sudo pacman -S ttf-meslo-nerd-font-powerlevel10k
# Reiniciar terminal
```

### Problema 5: "FZF no funciona"
```bash
# Verificar instalación
pacman -Q fzf
# Recargar configuración
source ~/.zshrc
# Probar manualmente
fzf --version
```

### Problema 6: "Aliases de DisplayPort fallan"
```bash
# Normal en VM, verificar que estén condicionales
grep -A 3 "DisplayPort" ~/.zshrc
# Deberían estar dentro de un if que verifica xrandr
```

---

## 📊 Checklist de Validación Completa

### ✅ Pre-Instalación
- [ ] VM creada con 4GB RAM y 20GB disco
- [ ] Arch Linux base instalado
- [ ] Usuario no-root creado
- [ ] sudo configurado
- [ ] NetworkManager activo
- [ ] Internet funcional

### ✅ Instalación
- [ ] Repositorio clonado sin errores
- [ ] `./install.sh` ejecutado sin errores
- [ ] Oh-My-Zsh instalado
- [ ] PowerLevel10k instalado
- [ ] Todos los paquetes instalados (verify con `./verify.sh`)
- [ ] Archivos de configuración copiados

### ✅ Post-Instalación
- [ ] ZSH se inicia sin errores
- [ ] Prompt PowerLevel10k visible
- [ ] FZF funciona (Ctrl+T, Ctrl+R, Ctrl+F)
- [ ] Zoxide funciona (cd y z)
- [ ] Bat muestra syntax highlighting
- [ ] Eza muestra iconos
- [ ] Tmux funciona con prefijo Ctrl+a
- [ ] Ripgrep busca correctamente
- [ ] fd encuentra archivos
- [ ] GitHub CLI instalado (gh --version)
- [ ] JQ procesa JSON
- [ ] Pass instalado
- [ ] Stow instalado
- [ ] Btop funciona

### ✅ Portabilidad
- [ ] No hay username hardcoded
- [ ] EDITOR tiene fallback correcto
- [ ] PATH no contiene directorios inexistentes
- [ ] PNPM_HOME usa $HOME
- [ ] PROJECTS_DIR se adapta al idioma
- [ ] Nano backups directory existe
- [ ] Kitty no tiene warnings de ml4w
- [ ] Aliases condicionales funcionan

### ✅ Cleanup Testing
- [ ] Backup creado antes de reinstalar
- [ ] Reinstalación sin conflictos
- [ ] `./install.sh update` funciona
- [ ] `./verify.sh` pasa todas las verificaciones

---

## 🎯 Casos de Uso para Testing

### Caso 1: Usuario en Inglés
```bash
# Crear VM con locale en_US.UTF-8
# Verificar que PROJECTS_DIR apunta a ~/Documents/Projects
echo $PROJECTS_DIR
```

### Caso 2: Usuario en Español
```bash
# Crear VM con locale es_ES.UTF-8
# Verificar que PROJECTS_DIR apunta a ~/Documentos/PROYECTOS
echo $PROJECTS_DIR
```

### Caso 3: VM sin Neovim
```bash
# No instalar neovim
# Verificar que EDITOR hace fallback a vim o nano
echo $EDITOR
```

### Caso 4: VM Mínima
```bash
# Instalar solo con --skip-packages después de instalar dependencias mínimas
sudo pacman -S zsh git
./install.sh --skip-packages
# Verificar qué falta
./verify.sh
```

---

## 📝 Reporte de Testing

Después de cada test, documentar:

```markdown
### Test Report - [FECHA]

**VM Config:**
- RAM: 4GB
- Disco: 20GB
- Locale: en_US.UTF-8
- Usuario: testuser

**Resultados:**
- Instalación: ✅ / ❌
- Verificación (verify.sh): X errores, Y warnings
- Herramientas funcionando: X/13

**Problemas Encontrados:**
1. [Descripción del problema]
   - Severidad: CRÍTICO / ALTO / MEDIO / BAJO
   - Solución aplicada: [descripción]

**Tiempo Total:** XX minutos

**Conclusión:** APROBADO / REQUIERE CORRECCIONES
```

---

## 🔄 Automatización del Testing

### Script de Testing Automatizado (Opcional)

```bash
#!/bin/bash
# test_vm.sh - Automatiza testing básico

# Ejecutar dentro de la VM
cd ~/Dreamcoder_dots

echo "=== INICIANDO TESTING AUTOMATIZADO ==="

# Test 1: Instalación
./install.sh || exit 1

# Test 2: Verificación
./verify.sh || echo "Verificación falló"

# Test 3: Herramientas
for cmd in fzf zoxide bat eza fd rg gh jq stow pass btop tmux; do
    if command -v "$cmd" &>/dev/null; then
        echo "✅ $cmd"
    else
        echo "❌ $cmd"
    fi
done

# Test 4: Configuraciones
for file in ~/.zshrc ~/.bashrc ~/.tmux.conf ~/.nanorc; do
    if [[ -f "$file" ]]; then
        echo "✅ $file"
    else
        echo "❌ $file"
    fi
done

echo "=== TESTING COMPLETADO ==="
```

---

## 🎓 Tips para Testing Eficiente

1. **Snapshots:** Crea snapshot de la VM después de la instalación base
2. **Scripts:** Usa scripts para acelerar reinstalaciones
3. **Logs:** Guarda logs de cada instalación para debugging
4. **Comparación:** Compara múltiples VMs con diferentes configuraciones
5. **Documentación:** Documenta cada problema encontrado y su solución

---

**Última actualización:** 2025-10-29
**Versión del proyecto:** 3.0.0
