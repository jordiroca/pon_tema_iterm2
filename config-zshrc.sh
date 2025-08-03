#!/usr/bin/env bash
#
# DESCRIPTION: config-zshrc Configures .zshrc file to change iTerm2 theme on chpwd
#
# VERSION: 0.0.1
#
# OPTIONS:
#   -h, --help    Display this message.
#
# AUTHOR: Jordi Roca
# CREATED: 2025/08/02 11:32
#
# GITHUB: https://github.com/jordiroca/
# WEBSITE: https://jordiroca.com
#
# LICENSE: See LICENSE file.
#

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

instala_en_zshrc() {
  cat << 'EOF' >> ~/.zshrc

# Carga la librería de zsh para añadir hooks
autoload -U add-zsh-hook

# Función para cambiar el tema de iTerm2
cambiar_tema_iterm2() {
  local theme_name="$1"
  osascript -e "tell application \"iTerm2\"" \
            -e "tell current session of current window" \
            -e "set color preset to \"$theme_name\"" \
            -e "end tell" \
            -e "end tell"
}

# Función hooked para:
# - cambiar el tema de iTerm2 cuando se cambia de directorio
# - activar el entorno virtual local de python si existe
hooked_chpwd() {
  # Handle iTerm2 theme switching if .iterm2theme file exists
  local directorio_actual="$PWD"
  local tema_actual
  tema_actual=$(osascript -e 'tell application "iTerm2" to get color preset of current session of current window')
  local tema_activado=false
  local venv_activado=false

  # Loop to traverse up the directory tree
  while [[ "$directorio_actual" != "/" ]]; do
    # Handle Python virtualenv activation/deactivation
    if [[ "$venv_activado" == false ]]; then
      if [[ -f "$directorio_actual/.venv/bin/activate" ]]; then
        venv_activado=true
        if [[ "$VIRTUAL_ENV" != "$directorio_actual/.venv" ]]; then
          # shellcheck source=/dev/null
          source "$directorio_actual/.venv/bin/activate"
          echo "🔁 Activated entorno virtual: .venv"
        fi
      fi
    fi

    # Handle changing iTerm2 theme per folder
    if [[ "$tema_activado" == false ]]; then
      if [[ -f "$directorio_actual/.iterm2theme" ]]; then
        tema_activado=true
        nombre_tema=$(tr -d '\n' < "$directorio_actual/.iterm2theme")
        if [[ "$tema_actual" != "$nombre_tema" ]]; then
          cambiar_tema_iterm2 "$nombre_tema"
          echo "🎨 Cambiado tema de iTerm2 a: $nombre_tema"
        fi
      fi
    fi

    if [[ "$venv_activado" == true && "$tema_activado" == true ]]; then
      break
    fi
    # Move up one directory
    directorio_actual=$(dirname "$directorio_actual")
  done

  # If no theme was activated, reset to default
  if [[ "$tema_activado" == false ]]; then
    if [[ ! -f ~/.iterm2theme ]]; then
      nombre_tema_por_defecto="Solarized Dark"
      echo "$nombre_tema_por_defecto" > ~/.iterm2theme
    else
      nombre_tema_por_defecto=$(tr -d '\n' < ~/.iterm2theme)
    fi
    if [[ "$tema_actual" != "$nombre_tema_por_defecto" ]]; then
      cambiar_tema_iterm2 "$nombre_tema_por_defecto"
      echo "🎨 Cambiado tema de iTerm2 a: $nombre_tema_por_defecto"
    fi
  fi
}

add-zsh-hook chpwd hooked_chpwd
EOF
}

pedir_confirmacion() {
  local prompt=${1:-"Are you sure?"}
  read -rp "$prompt (Y/n)" -n 1 -r
  echo
  if [[ $REPLY == [Yy] ]] || [[ -z $REPLY ]]; then
    return 0
  fi
  return 1
}

bye() {
  local retcode=${1:-0}
  local message=${2:-"Bye!"}
  printf "\n"
  echo "$message"
  printf "\n"
  exit "$retcode"
}

ALIAS_INSTALADO=false

faltan_basicos(){
  printf "\n"
  echo "AVISO:"
  echo "Faltan programas básicos como curl, brew, uv y fzf."
  echo "Antes de configurar virguerías para iTerm2, instala estos programas."
  printf "\n"
  bye 1 "Instala curl, brew, uv y fzf y vuelve a ejecutar el programa cuando quieras!"
}

como_manualmente() {
  printf "\n"
  echo "Crea un archivo .iterm2theme con el nombre del tema de iTerm2 que quieres usar en el directorio y subdirectorios."
  printf "\n"
}

como_pon_tema(){
  printf "\n"
  if [ "$ALIAS_INSTALADO" = true ]; then
    echo "Puedes ejecutar el alias pon_tema_iterm2 para establecer el tema de iTerm2 que quieres usar en el directorio y subdirectorios."
  else
    echo "Puedes ejecutar el programa $SCRIPT_DIR/pon_tema_iterm2.py para establecer el tema de iTerm2 que quieres usar en el directorio y subdirectorios."
  fi
  printf "\n"
}

instrucciones() {
  printf "\n"
  echo "Este programa añadirá un hook a .zshrc para cambiar el tema de iTerm2 cuando cambies de directorio"
  printf "\n"
  echo "Licencia MIT © 2025 Jordi Roca"
  printf "\n"
}

instrucciones

# Check if we are on a mac
if [[ "$(uname -s)" != "Darwin" ]]; then
  bye 1 "Este programa solo funciona en macOS, lo siento!"
fi

# Check if we are using zsh
if [[ "$(basename "$SHELL")" != "zsh" ]]; then
  bye 1 "Por favor ejecuta este programa con zsh, no con $SHELL" 
fi

# Check if .zshrc already contains the hook
if grep -q "hooked_chpwd" ~/.zshrc; then
  como_pon_tema
  bye 1 "Ya está instalado el hook en ~/.zshrc"
fi

echo "Este programa añadirá un hook a ~/.zshrc para cambiar el tema de iTerm2 automáticamente."
if ! pedir_confirmacion "¿Quieres continuar?"; then
  bye 1 "Vuelve a ejecutar el programa cuando quieras instalar el hook."
fi

instala_en_zshrc

printf "\n"
echo "Hook añadido a ~/.zshrc"
printf "\n"

# Instalar un alias
ALIAS_INSTALADO=false
if ! grep -q "alias pon_tema_iterm2=" ~/.zshrc; then
  if pedir_confirmacion "¿Quieres instalar el alias pon_tema_iterm2?"; then
    # Lío de comillas para que funcione en zsh
    echo "alias pon_tema_iterm2=\"python3 \\\"$SCRIPT_DIR/pon_tema_iterm2.py\\\"\"" >> ~/.zshrc
    ALIAS_INSTALADO=true
  fi
else
  ALIAS_INSTALADO=true
fi

# Comprobar si curl está instalado
if ! command -v curl &> /dev/null; then
  faltan_basicos
fi  

# Comprobar si brew está instalado
if ! command -v brew &> /dev/null; then
  faltan_basicos
fi  

# Comprobar si uv está instalado
if ! command -v uv &> /dev/null; then
  echo "AVISO:"
  echo "uv no está instalado."
  echo "Si lo instalas puedes ejecutar el programa pon_tema_iterm2.py para establecer el tema para un directorio."
  printf "\n"
  if ! pedir_confirmacion "¿Quieres instalar uv?"; then
    como_manualmente
    bye 1
  fi
  # On macOS and Linux.
  echo "Instalando uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  echo "uv instalado."
  printf "\n"
fi

# Comprobar si fzf está instalado
if ! command -v fzf &> /dev/null; then
  echo "AVISO:"
  echo "fzf no está instalado."
  echo "Si lo instalas, el programa pon_tema_iterm2.py te permitirá establecer el tema para un directorio de manera interactiva."
  printf "\n"
  if ! pedir_confirmacion "Quieres instalar fzf?"; then
    como_pon_tema
    bye 1
  fi
  # On macOS and Linux.
  echo "Instalando fzf..."
  brew install fzf
  echo "fzf instalado."
  printf "\n"
fi

como_pon_tema

bye
