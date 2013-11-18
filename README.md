matlab-utils
============

The purpose of this module is to incorporate into Matlab some basic functionality that the language is mysteriously lacking.  This module takes a Functional Programming aproach to simplifying everyday Matlab code with general-purpose utility functions that abstract away much of the convolution of Matlab code into (hopefully!) more intuitive functions.

#intro:

The module can be imported by typing something like:
  
  <i><b>utils = getUtils;</b></i>

After including, 'utils' becomes a struct of functions and organized submodules in several categories. Calling syntax for any of the included functions looks like:

  <i><b>newarray = utils.std.reverse(array);</b></i>

Due to the nested nature of the structured 'utils' module, calling syntax for functions can often grow rather ungainly. Because of this, the module includes a function 'utils.globalize()' to import nested functions into the global workspace.  Calling the globalize function looks like:

  <i><b>utils.globalize('utils.std.reverse');</b></i>

which would import the function 'utils.std.reverse' into the global workspace. Thereafter, calling the reverse function would be simplified to:

  <i><b>newarray = reverse(array);</b></i>
  
Similar to the above method, submodules can also be imported individually. For example:

  <i><b>utils.globalize('utils.std');</b></i>
  
Which results in the 'std' submodue being imported into the base workspace. Its functions may then be accessed as:

  <i><b>newarray = std.reverse(array);</b></i>
  
#contents:

utils
  - units
    - base26()
    - hexavigesimal()
    - alphabetical_cast()
    - numerical_cast()
    - binary
      - xor
      - or
      - and
    - sequence()
    - numdigits()
  - operators
    - map()
    - ternary()
    - slice()
    - split()
    - split()
    - strsplit()
    - arraysplit()
    - index()
    - strip()
    - downsample()
    - filter()
    - reverse()
    - bkwd()
  - exp
    - piecewise()
    - logical_eval()
    - bool()
  - os
    - path
      - like()
  - xl
    - new()
    - size()
    - getRow()
    - set()
    - addSheet()
    - addSheets()
  - std
    - (proxy for 'utils.operators')
  - time
    - datetime()
  - globalize()
