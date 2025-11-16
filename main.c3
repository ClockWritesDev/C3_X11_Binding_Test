import linux::x11;
import std::io;

bool quit = false;

fn void closeX11Window(XDisplay* display, XWindow window) {
    x11::destroyWindow(display, window);
    x11::closeDisplay(display);
}

fn int main() {
	XDisplay* display = x11::openDisplay(null);

    XWindow root = x11::defaultRootWindow(display);

    XWindow window = x11::createSimpleWindow(
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

    XMask event_mask = x11::EXPOSURE_MASK
                    | x11::KEY_PRESS_MASK | x11::KEY_RELEASE_MASK
                    | x11::BUTTON_PRESS_MASK | x11::BUTTON_RELEASE_MASK;
    x11::selectInput(display, window, event_mask);
    x11::mapWindow(display, window);

    XAtom wm_delete_window = x11::internAtom(display, x11::WM_DELETE_WINDOW, x11::FALSE);
    x11::setWMProtocols(display, window, &wm_delete_window, 1);

    XEvent x_events;

	while (!quit) {
        //events not working properly
        x11::nextEvent(display, &x_events);
		switch(x_events.type) {
			case x11::KEY_PRESS:
				io::printfn("%d", x_events.x_key.keycode);
				if (x_events.x_key.keycode == 0x09) {quit=true;}
				break;
            case x11::CLIENT_MESSAGE:
                XAtom wm_protocol = x11::internAtom(display, x11::WM_PROTOCOLS, x11::FALSE);

                if (x_events.x_client.message_type == (Card64)wm_protocol && 
                    x_events.x_client.data.l[0] == (Int64)wm_delete_window) {
                    quit = true;
                }
                break;
		}
	}

	closeX11Window(display, window);
	return 0;
}