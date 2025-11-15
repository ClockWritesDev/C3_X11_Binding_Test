module linux::main;
import linux::x11;

bool quit = false;

fn void closeX11Window(Display* display, Window window) {
    x11::x11_XDestroyWindow(display, window);
    x11::x11_XCloseDisplay(display);
}

int main() {
	Display* display = x11::x11_XOpenDisplay(null);
    if(display == null) { return x11::X11_COULD_NOT_OPEN_DISPLAY?; }

    Window root = x11::x11_DefaultRootWindow(display);
    if(root == null) { return x11::X11_COULD_NOT_FIND_ROOT?; }

    Window window = x11::x11_XCreateSimpleWindow(
	display,
    root,
    (Int32)window_size_pos.x,
    (Int32)window_size_pos.y,
    (Card64)window_size_pos.w,
    (Card64)window_size_pos.h,
    0,
    0,
    0xffffffff
	);
    if(window == null) { return x11::X11_COULD_NOT_CREATE_WINDOW?; }

    x11::x11_XMapWindow(display, window);

    Atom wm_delete_window = x11::x11_XInternAtom(display, x11::WM_DELETE_WINDOW, x11::FALSE);
    x11::x11_XSetWMProtocols(display, window, &wm_delete_window, 1);

    XEvent x_events;
	x11::x11_XNextEvent(display, &x_events);

	while (!quit) {
		switch(x_events.type) {
			case x11::KEYPRESS:
				if(x_events.xkey.keycode)
				break;
		}
	}

	closeX11Window(display, window);
	return 0;
}