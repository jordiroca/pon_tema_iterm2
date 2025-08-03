# Selector de temas de iTerm2 🎨

> **Gestión inteligente de esquemas de color de iTerm2 por carpeta para macOS**

Cambia automáticamente el esquema de color de iTerm2 según el directorio de trabajo actual. No te pierdas en tu terminal con las pistas visuales que te ayudan a reconocer al instante en qué proyecto o entorno te encuentras.

## ✨ Características

- **🎯 Esquemas de color por carpeta**: Asigna perfiles de color únicos de iTerm2 a directorios específicos usando archivos `.iterm2theme`
- **⚡ Cambio automático**: Cambia de tema sin problemas mientras navegas entre carpetas mediante ganchos zsh
- **🔧 Configuración cero**: Funciona de inmediato con valores predeterminados sensatos
- **🎨 Selección visual de temas**: Interfaz de usuario interactiva para seleccionar y aplicar temas
- **🐍 Integración con entornos virtuales**: Activa automáticamente los entornos virtuales de Python al acceder a directorios

## 🚀 Inicio rápido

### Requisitos previos

- macOS con iTerm2
- Python 3.8+
- shell zsh (predeterminado en macOS)
- Esquemas de color de iTerm2 instalados

### Instalación

1. Clonar este repositorio:

```bash
git clone https://github.com/yourusername/hook_chpwd_iterm2_theme.git
cd hook_chpwd_iterm2_theme
```

2. Instala el gancho zsh (añade la configuración a tu ~/.zshrc):
```bash
./config-zshrc.sh
```

3. Reinicia tu terminal o descarga tu ~/.zshrc:
```bash
source ~/.zshrc
```

## 🛠️ Configuración

### Configurar temas de carpeta

#### Método 1: Selección interactiva de temas

Si copias el archivo `set_folder_theme.py` a un directorio en tu PATH, puedes ejecutarlo desde cualquier directorio y se creará un archivo `.iterm2theme` en el directorio actual.

Dirígete a cualquier directorio y ejecuta el selector de temas:

```bash
set_folder_theme.py
```

Esto abre una interfaz de terminal interactiva donde puedes:
- 🎨 Explorar todos los esquemas de color disponibles de iTerm2
- ✅ Seleccionar un tema para el directorio actual
- 📄 Crear un archivo `.iterm2theme` en el directorio actual

#### Método 2: Configuración manual

Crea un archivo `.iterm2theme` en cualquier directorio para configurar su tema:

```bash
echo "Regular" > .iterm2theme
```

El tema de iterm2 se aplicará automáticamente al acceder a este directorio o a cualquier subdirectorio.

#### Tema predeterminado global
Establezca un tema predeterminado global creando `~/.iterm2theme`:

```bash
echo "Regular" > ~/.iterm2theme
```

### Cómo funciona

El sistema utiliza el gancho `chpwd` de zsh para:
1. **Detectar cambios de directorio** al usar `cd`
2. **Buscar archivos `.iterm2theme`** en el directorio actual y los directorios superiores
3. **Aplicar el tema** mediante la API AppleScript de iTerm2
4. **Volver al valor predeterminado** si no se encuentra el archivo `.iterm2theme`
5. **Activar entornos virtuales de Python** automáticamente cuando existan directorios `.venv`

## 📋 Comandos disponibles

| Comando | Descripción |
|-----------------------|----------------------------------------------------------|
| `set_folder_theme.py` | Iniciar el selector de temas interactivo para el directorio actual |
| `./config-zshrc.sh` | Instalar la configuración del gancho zsh en ~/.zshrc |

## 🔧 Cómo funciona

Esta utilidad aprovecha la API AppleScript de iTerm2 y los ganchos zsh para cambiar dinámicamente los esquemas de color según el directorio de trabajo actual. Funciona así:

1. **Conectando con los cambios del directorio de la shell** mediante el gancho `chpwd` de zsh
2. **Buscando archivos `.iterm2theme`** en los directorios actual y superior
3. **Enviando comandos de AppleScript a iTerm2** para cambiar los esquemas de color al instante
4. **Activando entornos virtuales de Python** cuando se detectan directorios `.venv`
5. **Restableciendo el tema predeterminado global** cuando no se configura ningún tema específico

## 🎯 Casos de uso

Perfecto para desarrolladores que:
- 🏢 Trabajan en varios proyectos de clientes simultáneamente
- 🌙 Quieren distinguir visualmente entre proyectos profesionales y personales
- 🐍 Usan entornos virtuales de Python y desean la activación automática
- 🐛 Necesitan cambiar rápidamente de contexto entre diferentes entornos
- 🎨 Les encantan las terminales atractivas y organizadas

## 📦 Dependencias y opciones de instalación

### Instalación automática (recomendada)
El script utiliza el gestor de paquetes **uv** a través de su shebang para la instalación automática Gestión de dependencias:

```bash
# Se ejecuta automáticamente con uv (requiere que uv esté instalado)
set_folder_theme.py
```

**¿Qué es uv?** uv es un rápido gestor de paquetes de Python que instala automáticamente las dependencias necesarias al ejecutar el script. Si tiene uv instalado, las dependencias (`iterm2`, `rich`) se descargarán y almacenarán en caché automáticamente en la primera ejecución.

### Instalación manual (alternativa)
Si prefiere no usar uv, tiene estas opciones:

#### Opción 1: Instalar uv primero
```bash
# Instalar uv (si aún no está instalado)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Ejecutar el script normalmente
set_folder_theme.py
```

#### Opción 2: Usar Python 3 directamente
```bash
# Instalar las dependencias manualmente
pip3 install iterm2 rich

# Ejecutar con Python 3 (sin necesidad de configuración)
python3 set_folder_theme.py
```

#### Opción 3: Usar pipx para una instalación aislada
```bash
# Instalar dependencias en un entorno aislado
pipx install iterm2 rich

# Ejecutar con Python 3
python3 set_folder_theme.py
```

### Dependencias requeridas
- `iterm2` - Biblioteca de Python para scripts de iTerm2
- `rich` - Formato de terminal atractivo
- `curses` - Interfaz de terminal (integrada en la biblioteca estándar de Python)

## 🚀 Ejemplos prácticos

### Configurar un proyecto de trabajo con el tema Drácula

**Usando uv (automático):**
```bash
cd ~/projects/work-project
set_folder_theme.py
# Seleccionar "Drácula" en el menú interactivo
# Crear un archivo .iterm2theme con "Drácula"
```

**Usando Python 3 (manual):**
```bash
cd ~/proyectos/proyecto-de-trabajo
python3 set_folder_theme.py
# Seleccionar "Drácula" en el menú interactivo
# Crear el archivo .iterm2theme con "Drácula"
```

### Configurar un proyecto personal con Solarized Light
```bash
cd ~/proyectos/blog-personal
echo "Solarized Light" > .iterm2theme
```

### Establecer el tema predeterminado global
```bash
echo "Regular" > ~/.iterm2theme
```

### Demostración del flujo de trabajo
```bash
# Ir al proyecto de trabajo (cambia automáticamente a Drácula)
cd ~/proyectos/proyecto-de-trabajo

# Ir al proyecto personal (cambia automáticamente a Solarized Light)
cd ~/proyectos/blog-personal

# Ir al directorio sin tema específico (recurre al tema predeterminado global)
cd ~/Descargas
```

### Configuración rápida para nuevos usuarios
```bash
# 1. Instalar el gancho zsh
./config-zshrc.sh

# 2. Reiniciar la terminal o source ~/.zshrc
source ~/.zshrc

# 3. Configurar el primer tema del proyecto
cd ~/my-project
set_folder_theme.py # o python3 set_folder_theme.py
```

## 🤝 Contribuciones

¡Agradecemos tus contribuciones! Consulta nuestra [Guía de Contribuciones](CONTRIBUTING.md) para más detalles.

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT; consulta el archivo [LICENCIA](LICENSE) para más detalles.

## 🙏 Agradecimientos

- Creado con cariño para la comunidad de iTerm2
- Inspirado por la necesidad de una mejor organización de la terminal
- Gracias a todos los increíbles creadores de esquemas de color de iTerm2

---

<div align="center">
<p><strong>Hecho con cariño para los desarrolladores que trabajan en la terminal</strong></p>
<p><em>¡Marca ⭐ este repositorio si te ayuda a mantenerte organizado!</em></p>
</div>