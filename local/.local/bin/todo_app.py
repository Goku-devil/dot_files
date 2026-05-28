import tkinter as tk
import json
import os
import sys

TODO_FILE = os.path.expanduser("~/.python_todos.json")

# --- WAYBAR STATUS CHECK ---
def load_tasks():
    if os.path.exists(TODO_FILE):
        with open(TODO_FILE, "r") as f:
            return json.load(f)
    return []

if len(sys.argv) > 1 and sys.argv[1] == "status":
    tasks = load_tasks()
    active_count = sum(1 for t in tasks if not t.startswith("✓ "))
    tooltip_text = "\n".join(tasks) if tasks else "No tasks today!"
    print(json.dumps({"text": str(active_count), "tooltip": tooltip_text}))
    sys.exit(0) 

# ==========================================
# GUI APPLICATION 
# ==========================================

# Theme Colors (Catppuccin Mocha inspired)
BG_MAIN = "#1e1e2e"      # Base (Main window)
BG_INPUT = "#313244"     # Surface0 (Input field)
TEXT_MAIN = "#cdd6f4"    # Text
TEXT_DONE = "#a6e3a1"    # Green (Done items)
ACCENT = "#cba6f7"       # Mauve (Title text)
BG_DARK = "#11111b"      # Crust

# Button Colors & Hover States
BTN_ADD = "#89b4fa"      
BTN_ADD_HOVER = "#b4befe"
BTN_DONE = "#a6e3a1"     
BTN_DONE_HOVER = "#94e2d5"
BTN_DEL = "#f38ba8"      
BTN_DEL_HOVER = "#eba0ac"
BTN_EXIT_HOVER = "#f38ba8" 

def save_tasks():
    tasks = listbox.get(0, tk.END)
    with open(TODO_FILE, "w") as f:
        json.dump(tasks, f)

def add_task(event=None):
    task = entry.get().strip()
    if task:
        listbox.insert(tk.END, task)
        entry.delete(0, tk.END)
        save_tasks()

def delete_task():
    try:
        selected_index = listbox.curselection()[0]
        listbox.delete(selected_index)
        save_tasks()
    except IndexError:
        pass

def toggle_done():
    try:
        selected_index = listbox.curselection()[0]
        task = listbox.get(selected_index)
        
        if not task.startswith("✓ "):
            listbox.delete(selected_index)
            listbox.insert(selected_index, f"✓ {task}")
            listbox.itemconfig(selected_index, {'fg': TEXT_DONE})
        else:
            listbox.delete(selected_index)
            listbox.insert(selected_index, task[2:])
            listbox.itemconfig(selected_index, {'fg': TEXT_MAIN})
            
        save_tasks()
    except IndexError:
        pass

# --- Window Setup ---
root = tk.Tk()
root.title("Minimal Todo")
root.geometry("450x600")
root.configure(bg=BG_MAIN) # Base background directly on root

# Main App Frame (No custom border frames around it)
main_frame = tk.Frame(root, bg=BG_MAIN)
main_frame.pack(fill=tk.BOTH, expand=True)

# --- Custom Title Bar & Exit Button ---
top_bar = tk.Frame(main_frame, bg=BG_MAIN)
top_bar.pack(fill=tk.X, padx=15, pady=10)

lbl_title = tk.Label(top_bar, text="Tasks", bg=BG_MAIN, fg=ACCENT, font=("JetBrainsMono Nerd Font", 12, "bold"))
lbl_title.pack(side=tk.LEFT)

# Helper function for hover effects
def create_btn(parent, text, cmd, bg_col, hover_col, fg_col=BG_DARK):
    btn = tk.Button(
        parent, text=text, command=cmd, bg=bg_col, fg=fg_col, 
        activebackground=hover_col, activeforeground=BG_DARK,
        relief="flat", font=("JetBrainsMono Nerd Font", 10, "bold"), 
        cursor="hand2", borderwidth=0, highlightthickness=0
    )
    btn.bind("<Enter>", lambda e: btn.config(bg=hover_col))
    btn.bind("<Leave>", lambda e: btn.config(bg=bg_col))
    return btn

# The Exit Button
btn_exit = create_btn(top_bar, "", root.destroy, BG_MAIN, BTN_EXIT_HOVER, fg_col=TEXT_MAIN)
btn_exit.config(width=3, font=("JetBrainsMono Nerd Font", 12))
btn_exit.bind("<Enter>", lambda e: btn_exit.config(bg=BTN_EXIT_HOVER, fg=BG_DARK))
btn_exit.bind("<Leave>", lambda e: btn_exit.config(bg=BG_MAIN, fg=TEXT_MAIN))
btn_exit.pack(side=tk.RIGHT)

# --- UI Layout ---
# Input Field
entry = tk.Entry(
    main_frame, 
    font=("JetBrainsMono Nerd Font", 14), 
    bg=BG_INPUT, 
    fg=TEXT_MAIN, 
    insertbackground=TEXT_MAIN, 
    relief="flat",
    highlightthickness=0,
    borderwidth=5 
)
entry.pack(pady=(5, 20), padx=20, fill=tk.X)
entry.bind("<Return>", add_task)

# List Box for Tasks
listbox = tk.Listbox(
    main_frame, 
    font=("JetBrainsMono Nerd Font", 12), 
    bg=BG_MAIN, 
    fg=TEXT_MAIN, 
    selectbackground=BG_INPUT, 
    selectforeground=ACCENT, 
    relief="flat", 
    highlightthickness=0,
    borderwidth=0,
    activestyle="none" 
)
listbox.pack(pady=5, padx=20, fill=tk.BOTH, expand=True)

# Bottom Button Frame
btn_frame = tk.Frame(main_frame, bg=BG_MAIN)
btn_frame.pack(pady=20)

btn_add = create_btn(btn_frame, "Add", add_task, BTN_ADD, BTN_ADD_HOVER)
btn_add.config(width=10)
btn_add.pack(side=tk.LEFT, padx=10)

btn_done = create_btn(btn_frame, "Done/Undo", toggle_done, BTN_DONE, BTN_DONE_HOVER)
btn_done.config(width=12)
btn_done.pack(side=tk.LEFT, padx=10)

btn_del = create_btn(btn_frame, "Delete", delete_task, BTN_DEL, BTN_DEL_HOVER)
btn_del.config(width=10)
btn_del.pack(side=tk.LEFT, padx=10)

# --- Initialization ---
for item in load_tasks():
    listbox.insert(tk.END, item)
    if item.startswith("✓ "):
        listbox.itemconfig(tk.END, {'fg': TEXT_DONE})

root.mainloop()
