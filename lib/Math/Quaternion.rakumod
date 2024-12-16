unit class Math::Quaternion does Numeric;

# One real part (r), and three imaginary parts (i,j,k).
has Numeric ( $.r, $.i, $.j, $.k );

# Constructors: .new, .unit

multi method new() {
    self.bless: :r(0), :i(0), :j(0), :k(0);
}
multi method new(Real:D $r ) {
    self.bless: :$r, :i(0), :j(0), :k(0);
}
multi method new(Complex:D $c ) {
    self.bless: :r($c.re), :i($c.im), :j(0), :k(0);
}
multi method new(Real:D $r, Real $i, Real $j, Real $k ) {
    self.bless: :$r, :$i, :$j, :$k;
}

method unit() {
    self.bless: :r(1), :i(0), :j(0), :k(0);
}

# Utility methods:

method Str(::?CLASS:D:) {
    "$.r + {$.i}i + {$.j}j + {$.k}k";
}

method coeffs() { ( $.r, $.i, $.j, $.k ) } # All 4 components as a list.
method v()      { (      $.i, $.j, $.k ) } # Like .coeffs, but omitting .r

# Property methods:

# Following the example of p5 M::Q isreal(), our
# .is_real will return true when .is_zero is true. By extension,
# .is_complex       is true when .is_real is true,
# .is_complex       is true when .is_zero is true, and
# .is_imaginary     is true when .is_zero is true.

method is_real()      { all(      $.i, $.j, $.k ) == 0 }
method is_complex()   { all(           $.j, $.k ) == 0 }
method is_zero()      { all( $.r, $.i, $.j, $.k ) == 0 }
method is_imaginary() {      $.r                  == 0 }


# Math methods:

method norm() { sqrt [+] self.coeffs »**» 2 }

# Conjugate
method conj() {
    self.new: $.r, -$.i, -$.j, -$.k;
}

# Dot product
method dot($a: ::?CLASS:D $b ) {
    [+] $a.coeffs »*« $b.coeffs;
}

# Cross product
method cross($a: ::?CLASS:D $b ) {
    my @a_rijk            = $a.coeffs;
    my ( $r, $i, $j, $k ) = $b.coeffs;
    $a.new: ( [+] @a_rijk »*« ( $r, -$i, -$j, -$k ) ), # real
            ( [+] @a_rijk »*« ( $i,  $r,  $k, -$j ) ), # i
            ( [+] @a_rijk »*« ( $j, -$k,  $r,  $i ) ), # j
            ( [+] @a_rijk »*« ( $k,  $j, -$i,  $r ) ); # k
}

my sub sum-of-squares(*@list) {
    [+] ( @list »*« @list )
}

# Dot product of self with self
method squarednorm() {
    sum-of-squares(self.coeffs)
}

# Math operators:
multi sub prefix:<->(::?CLASS:D $a) is export {
    $a.new: |(-« $a.coeffs )
}

multi sub  infix:<eqv>(::?CLASS:D $a, ::?CLASS:D $b) is export {
    [and] $a.coeffs »==« $b.coeffs
}

multi sub infix:<+>(::?CLASS:D $a, Real:D $b) is export {
    $a.new: $b+$a.r, $a.i, $a.j, $a.k
}
multi sub infix:<+>(Real:D $b, ::?CLASS:D $a) is export {
    $a.new: $b+$a.r, $a.i, $a.j, $a.k
}
multi sub infix:<+>(::?CLASS:D $a, Complex:D $b ) is export {
    $a.new: $b.re+$a.r, $b.im+$a.i, $a.j, $a.k
}
multi sub infix:<+>(Complex:D $b, ::?CLASS:D $a) is export {
    $a.new: $b.re+$a.r, $b.im+$a.i, $a.j, $a.k
}
multi sub infix:<+>(::?CLASS:D $a, ::?CLASS:D $b) is export {
    $a.new: |( $a.coeffs »+« $b.coeffs )
}

multi sub infix:<->(::?CLASS:D $a, Real $b) is export {
    $a.new: $a.r-$b, $a.i, $a.j, $a.k
}
multi sub infix:<->(Real:D $b, ::?CLASS:D $a) is export {
    $a.new: $b-$a.r,-$a.i,-$a.j,-$a.k
}
multi sub infix:<->(::?CLASS:D $a, Complex:D $b) is export {
    $a.new: $a.r-$b.re, $a.i-$b.im,  $a.j,  $a.k
}
multi sub infix:<->(Complex:D $b, ::?CLASS:D $a ) is export {
    $a.new: $b.re-$a.r, $b.im-$a.i, -$a.j, -$a.k
}
multi sub infix:<->(::?CLASS:D $a, ::?CLASS:D $b ) is export {
    $a.new: |( $a.coeffs »-« $b.coeffs )
}

multi sub infix:<*>(::?CLASS:D $a, Real:D $b) is export {
    $a.new: |( $a.coeffs »*» $b )
}
multi sub infix:<*>(Real:D $b, ::?CLASS:D $a) is export {
    $a.new: |( $a.coeffs »*» $b )
}
multi sub infix:<*>(::?CLASS:D $a, Complex:D $b) is export {
    $a.cross( $a.new($b) )
}
multi sub infix:<*>(Complex:D $b, ::?CLASS:D $a ) is export {
    $a.new($b).cross($a)
}
multi sub infix:<*>(::?CLASS:D $a, ::?CLASS:D $b ) is export {
    $a.cross($b)
}

proto sub infix:<⋅>(|) is export {*}
multi sub infix:<⋅>(::?CLASS:D $a, Complex:D $b) {
    $a.dot($a.new: $b)
}
multi sub infix:<⋅>(Complex:D $b, ::?CLASS:D $a) {
    $a.dot($a.new: $b)
}
multi sub infix:<⋅>(::?CLASS:D $a, ::?CLASS:D $b) {
    $a.dot($b)
}

multi sub infix:</>(::?CLASS:D $a, Real:D $b) is export {
    $a.new: |( $a.coeffs »/» $b )
}
multi sub  infix:</>(Real:D $b, ::?CLASS:D $a) is export {
    die "p/q is ambiguous, because it does not specify whether q divides on the left or the right."
}
# XXX Real / Q *is* well-defined, according to Dr. Bales. Need to test.
multi sub  infix:</>(::?CLASS:D $a, ::?CLASS:D $b ) is export {
    die "p/q is ambiguous, because it does not specify whether q divides on the left or the right."
}

# vim: expandtab shiftwidth=4
