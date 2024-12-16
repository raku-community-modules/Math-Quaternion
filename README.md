[![Actions Status](https://github.com/raku-community-modules/Math-Quaternion/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/Math-Quaternion/actions) [![Actions Status](https://github.com/raku-community-modules/Math-Quaternion/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/Math-Quaternion/actions) [![Actions Status](https://github.com/raku-community-modules/Math-Quaternion/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/Math-Quaternion/actions)

NAME
====

Math::Quaternion - Hyper-complex numbers as objects with operators

SYNOPSIS
========

```raku
use Math::Quaternion;
```

DESCRIPTION
===========

This distribution implements an OO class for Quaternions, which are the simplest of the hyper-complex numbers. It adds the operators needed for basic math on the Qs, and should be a good base class for future modules to support the other hyper-complex numbers.

RECOMMENDATIONS
===============

I intend this module to be a high-quality example of Raku numeric OO, usable as a reference for future module authors.

WARNINGS
========

This module is a mostly-from-scratch re-implementation of Quaternions; its API differs from the excellent Perl Math::Quaternion module.

GLOSSARY
========

<table class="pod-table">
<thead><tr>
<th>Wikipedia</th> <th>Raku</th> <th>Boost</th> <th>dwh</th> <th>RAW</th>
</tr></thead>
<tbody>
<tr> <td>a</td> <td>$.r</td> <td>R_component_1</td> <td>real</td> <td>Real____________ part of a Q (as accessor)</td> </tr> <tr> <td>b</td> <td>$.i</td> <td>R_component_2</td> <td>imag_i</td> <td>First_ imaginary part of a Q (as accessor)</td> </tr> <tr> <td>c</td> <td>$.j</td> <td>R_component_3</td> <td>imag_j</td> <td>Second imaginary part of a Q (as accessor)</td> </tr> <tr> <td>d</td> <td>$.k</td> <td>R_component_4</td> <td>imag_k</td> <td>Third_ imaginary part of a Q (as accessor)</td> </tr> <tr> <td></td> <td>.coeffs</td> <td></td> <td></td> <td>(r, i, j, k) # List, not arrayref nor vector</td> </tr> <tr> <td></td> <td>.v</td> <td></td> <td></td> <td>(i, j, k) # List, not arrayref nor vector</td> </tr> <tr> <td></td> <td></td> <td></td> <td></td> <td>.</td> </tr> <tr> <td>norm</td> <td></td> <td>abs</td> <td>abs</td> <td>sum_of_squares( r,i,j,k ).sqrt</td> </tr> <tr> <td></td> <td></td> <td>norm</td> <td>norm</td> <td>sum_of_squares( r,i,j,k )</td> </tr> <tr> <td></td> <td></td> <td>abs(unreal)</td> <td>abs_imag</td> <td>sum_of_squares( i,j,k ).sqrt</td> </tr> <tr> <td></td> <td></td> <td>norm(unreal)</td> <td>norm_imag</td> <td>sum_of_squares( i,j,k )</td> </tr> <tr> <td></td> <td></td> <td></td> <td>arg</td> <td>atan2( sum_of_squares( i,j,k ).sqrt, r );</td> </tr> <tr> <td>distance</td> <td></td> <td></td> <td></td> <td>.</td> </tr> <tr> <td></td> <td></td> <td></td> <td></td> <td>.</td> </tr> <tr> <td></td> <td></td> <td>unreal</td> <td>imag</td> <td>self.( 0.0, i, j, k );</td> </tr> <tr> <td></td> <td></td> <td></td> <td>conj</td> <td>self.( r, -i, -j, -k );</td> </tr> <tr> <td></td> <td></td> <td></td> <td>operator *</td> <td>self.( r, -i, -j, -k );</td> </tr> <tr> <td></td> <td></td> <td></td> <td>signum</td> <td>absq = sum_of_squares( r,i,j,k ).sqrt; return ( absq == 0.0 ) ?? self !! self.new( r/absq, i/absq, j/absq, k/absq );</td> </tr> <tr> <td></td> <td></td> <td></td> <td>sqr</td> <td>self.( r*r - i*i - j*j - k*k, 2*r*i, 2*r*j, 2*r*k );</td> </tr> <tr> <td></td> <td></td> <td></td> <td>inverse</td> <td>self.new: (r,-i,-j,-k) / sum_of_squares( r,i,j,k )</td> </tr> <tr> <td>versor</td> <td></td> <td></td> <td></td> <td>self / sum_of_squares( r,i,j,k ).sqrt</td> </tr> <tr> <td></td> <td></td> <td></td> <td></td> <td>.</td> </tr> <tr> <td></td> <td></td> <td></td> <td>is_nan</td> <td>r != r or i != i or j != j or k != k;</td> </tr> <tr> <td></td> <td></td> <td></td> <td>is_inf</td> <td>any(r,i,j,k) == any(PosInf,NegInf)</td> </tr> <tr> <td></td> <td></td> <td></td> <td>is_neg_inf</td> <td>all(_,i,j,k) == 0 and r == NEG_INF;</td> </tr> <tr> <td></td> <td></td> <td></td> <td>is_pos_inf</td> <td>all(_,i,j,k) == 0 and r == POS_INF;</td> </tr> <tr> <td></td> <td></td> <td></td> <td>is_real_inf</td> <td>all(_,i,j,k) == 0 and r == any(POS_INF,NEG_INF);</td> </tr> <tr> <td></td> <td>is_real</td> <td></td> <td>is_real</td> <td>all(_,i,j,k) == 0</td> </tr> <tr> <td></td> <td>is_zero</td> <td></td> <td>is_zero</td> <td>all(r,i,j,k) == 0</td> </tr> <tr> <td></td> <td>is_complex</td> <td></td> <td></td> <td>all(_,_,j,k) == 0</td> </tr> <tr> <td></td> <td>is_imaginary</td> <td></td> <td>is_imaginary</td> <td>r == 0</td> </tr> <tr> <td></td> <td></td> <td></td> <td></td> <td>.</td> </tr> <tr> <td></td> <td></td> <td></td> <td>rotate</td> <td>When |q| == 1</td> </tr> <tr> <td></td> <td></td> <td></td> <td>sqrt</td> <td>.</td> </tr>
</tbody>
</table>

ACKNOWLEDGEMENTS
================

Thanks to:

  * Jonathan Chin for the original Perl Math::Quaternion module.

  * Solomon "colomon" Foster for encouraging this module's release.

  * Will "Coke" Coleda for fixes to match changes in Rakudo.

  * RosettaCode for the [challenge that provoked the initial code](https://rosettacode.org/wiki/Quaternion_type#Raku).

SEE ALSO
========

  * [http://en.wikipedia.org/wiki/Quaternion](http://en.wikipedia.org/wiki/Quaternion)

  * [http://en.wikipedia.org/wiki/Hypercomplex_number](http://en.wikipedia.org/wiki/Hypercomplex_number)

AUTHOR
======

Bruce Gray

COPYRIGHT AND LICENSE
=====================

Copyright 2010 - 2017 Bruce Gray

Copyright 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

