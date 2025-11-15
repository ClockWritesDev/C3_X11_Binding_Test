import linux::x11;
import std::io;

bool quit = false;

fn void closeX11Window(Display* display, Window window) {
    x11::x11_XDestroyWindow(display, window);
    x11::x11_XCloseDisplay(display);
}

fn int main() {
	Display* display = x11::x11_XOpenDisplay(null);

    Window root = x11::x11_DefaultRootWindow(display);

    Window window = x11::x11_XCreateSimpleWindow(
	display,
    root,
    (Int32)0,
    (Int32)0,
    (Card64)800,
    (Card64)640,
    0,
    0,
    0xffffffff
	);

    Mask event_mask = x11::EXPOSUREMASK
                    | x11::KEYPRESSMASK | x11::KEYRELEASEMASK
                    | x11::BUTTONPRESSMASK | x11::BUTTONRELEASEMASK;
    x11::x11_XSelectInput(display, window, event_mask);
    x11::x11_XMapWindow(display, window);

    Atom wm_delete_window = x11::x11_XInternAtom(display, x11::WM_DELETE_WINDOW, x11::FALSE);
    x11::x11_XSetWMProtocols(display, window, &wm_delete_window, 1);

    XEvent x_events;

	while (!quit) {
        //events not working properly
        x11::x11_XNextEvent(display, &x_events);
		switch(x_events.type) {
			case x11::KEYPRESS:
				if (x_events.xkey.keycode == 0xff1b) {quit=true;}
				break;
            case x11::CLIENTMESSAGE:
                Atom wm_protocol = x11::x11_XInternAtom(display, x11::WM_PROTOCOLS, x11::FALSE);

                if (x_events.xclient.message_type == (Card64)wm_protocol && 
                    x_events.xclient.data.l[0] == (Int64)wm_delete_window) {
                    quit = true;
                }
                break;
		}
	}

	closeX11Window(display, window);
	return 0;
}