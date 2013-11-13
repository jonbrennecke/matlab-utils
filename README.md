matlab-utils
============

The purpose of this module is to incorporate some functionality into matlab.

The module can be imported by typing something like:
  
  <i><b>utils = getUtils;</b></i>

After including, 'utils' becomes a struct of functions and organized submodules in several categories. Calling syntax for any of the included functions looks like:

  <i><b>newarray = utils.std.reverse(array);</b></i>

Due to the nested nature of the structured 'utils' module, calling syntax for functions can often grow rather ungainly. Because of this, the module includes a function 'utils.globalize()' to import nested functions into the global workspace.  Calling the globalize function looks like:

  <i><b>utils.globalize('utils.std.reverse');</b></i>

which would import the function 'utils.std.reverse' into the global workspace. Thereafter, calling the reverse function would be simplified to:

  <i><b>newarray = reverse(array);</b></i>
  
  
  
