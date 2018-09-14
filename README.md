
# Experiments in Delphi

An assortment of Delphi based coding experiments, which are mostly considered alpha, not optimized, and have incomplete features.

#### Balls - Collision Manager

A simple 2D collision manager that aims to optimize the detection of object collision.

![Balls](screenshots/balls-collision-manager.png)

#### Clock

An analogue desktop clock application.

![Clock](screenshots/clock.png)

#### Starfield

A simulation of stars travelling towards the screen.

![Starfield](screenshots/starfield.png)

#### Virtual Keyboard

A virtual keyboard simulator that uses Win32 to communicate and send key strokes to other applications.

![Virtual Keyboard](screenshots/virtual-keyboard.png)

##### Todo List:
* If DEL button is held down then send a CTRL+DEL key press
* A special button for SYMBOLS
* Holding a letter shows other variations/accents
  *  "-" -> "-", "�", "�"
  *  "$" -> "=W=", "�", "$", "�", "�"
  *  "&" -> "&", "�"
  *  "e" -> " ", " ", " ", "�", "�", "e", "�", "�"
  *  and others (a, c, e, i, d, n, o, u, y)
* Portrait/landscape mode (90 degrees rotation)
* When SHIFT button is held down the following should happen:
  * The SHIFT button is shaded
  * The letters are CAPITALIZED/LOWERED upon SHIFT state
* SHIFT button is initially down (active)
* Implement a prediction mode (e.g. T9, others)
  * Prediction mode should be controllable (enable/disable)

## License

Experiments in Delphi is licensed under the MIT License. See [LICENSE](LICENSE.md) for details.
