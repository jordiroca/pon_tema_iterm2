#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = [
#     "iterm2",
#     "rich",
# ]
# ///

import os
import asyncio
import iterm2
from importlib.metadata import version
from rich import print
from rich.console import Console
from rich.panel import Panel
from rich.rule import Rule
import shutil
import subprocess
import textwrap
import random

console = Console()

def comprueba_fzf():
    try:
        subprocess.check_output(["fzf", "--version"])
        return True
    except FileNotFoundError:
        console.print(Panel(
            "[bold red]fzf no está instalado[/bold red]\n\nInstálalo con: [bold green]brew install fzf[/bold green]",
            title="[bold red]Error[/bold red]",
            border_style="red",
            style="red",
            padding=1,
            expand=False
        ))
        return False
    except Exception as e:
        console.print(Panel(
            f"[bold red]Error al comprobar fzf:[/bold red]\n{str(e)}",
            title="[bold red]Error[/bold red]",
            border_style="red",
            style="red",    
            padding=1,
            expand=False
        ))
        return False

def menu_fzf(opciones):
    """Launch fzf to select a dish from the list.
    
    Returns:
        str: The selected dish name, or False if no selection was made.
    """
    # 1) Alinear numeros y cadenas de la misma longitud
    # Pendiente: poner suspensivos en cadenas largas
    ancho_num = max(2, len(str(len(opciones))))
    ancho_term = shutil.get_terminal_size().columns
    
    # Ojo que en pyhton la siguiente línea es: for -> enumerate(opciones) -> shorten con suspensivos -> zfill -> f-string
    raw = [f" {str(i + 1).zfill(ancho_num)}) {textwrap.shorten(d, width=ancho_term - ancho_num - 4, placeholder='…')} " for i, d in enumerate(opciones)]
    largo_max = min(max(len(r) for r in raw), ancho_term)
    lines = [r.ljust(largo_max + 1) for r in raw]

    # 2) Usar fzf como menu
    proc = subprocess.Popen(
        ["fzf", "--ansi", "--reverse", "--header", "Teclear para filtrar • ↑/↓ • Esc para salir • Intro para seleccionar"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        text=True,
    )

    out, _ = proc.communicate("\n".join(lines))
    rc = proc.returncode

    # 3) Si se pulsa Esc o no se selecciona nada
    if rc == 130 or not out.strip():  # 130 = Esc in fzf
        return False

    # 3) Devolver la seleccionada
    seleccionada = out.strip()
    idx = int(seleccionada.split(")")[0]) - 1
    return opciones[idx]


async def get_auth_cookie():
    """Obtener cookie de API de iTerm2"""
    if cookie := os.getenv("ITERM2_COOKIE"):
        return cookie
    
    proc = await asyncio.create_subprocess_shell(
        'osascript -e \'tell application "iTerm2" to request cookie\'',
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )
    stdout, _ = await proc.communicate()
    return stdout.decode().strip()

async def coge_temas_ordenados(connection) -> list: 
    """Obtener y mostrar lista ordenada de temas de iTerm2"""
    try:
        temas = await iterm2.ColorPreset.async_get_list(connection)
        return sorted(temas)
    except Exception as e:
        print(f"Error al obtener temas: {str(e)}")
        raise

async def cambiar_tema_iterm2(connection, theme_name):
    try:
        # Obtener el preset de color
        preset = await iterm2.ColorPreset.async_get(connection, theme_name)
        if not preset:
            print(f"Tema '{theme_name}' no encontrado")
            return
            
        # Obtener la aplicación y la sesión actual
        app = await iterm2.async_get_app(connection)
        if not app or not app.current_terminal_window:
            print("No se pudo obtener la ventana actual de iTerm2")
            return
            
        session = app.current_terminal_window.current_tab.current_session
        if not session:
            print("No se pudo obtener la sesión actual")
            return
            
        # Obtener el perfil y aplicar el preset
        profile = await session.async_get_profile()
        if profile:
            await profile.async_set_color_preset(preset)
            print(f"Tema '{theme_name}' aplicado exitosamente")
        else:
            print("No se pudo obtener el perfil de la sesión")
            
    except Exception as e:
        print(f"Error al cambiar tema: {str(e)}")
        raise
    
async def pon_tema_iterm2(connection):
    try:
        if not (cookie := await get_auth_cookie()):
            print("Error al obtener cookie de iTerm2")
            return 1
        api_version = version("iterm2")
        print(f"Version de API de iTerm2: {api_version}/{cookie}")
    
        iconos=["🎨","🖌️","🫟 ","🧑‍🎨","✍️"]
        temas = await coge_temas_ordenados(connection)
        if not comprueba_fzf():
            console.print(Rule("── Estos son los temas disponibles:",align="left"))
            for tema in temas:
                con_icono_aleatorio=random.choice(iconos) + " " + tema
                console.print(con_icono_aleatorio)
            console.print(Rule())
            return 1
        tema=menu_fzf(temas)
        if tema is not False:
            console.print(f"Tema seleccionado: {tema}")
            await cambiar_tema_iterm2(connection, tema)
            with open(".iterm2theme", "w") as f:
                f.write(tema)
        else:
            console.print("No se seleccionó ningún tema")
            return 1
    except Exception as e:
        print(f"Error al conectar con iTerm2: {str(e)}")
        return 1
    
    return 0

if __name__ == "__main__":
    iterm2.run_until_complete(pon_tema_iterm2)
    