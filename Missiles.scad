$fn = 40;

module mov(x=0, y=0, z=0)
{
    translate([x, y, z])
    children();
}

module rot(x=0, y=0, z=0)
{
    rotate([x, y, z])
    children();
}

function flatten(l) = [ for (a = l) for (b = a) b ] ;


module Head(diameter=10, length=10)
{
	R = (length*length+diameter*diameter/4)/diameter;
	max_alpha = atan2(length, R-diameter/2);
	delta = max_alpha/$fn;
	curve = [ for (i=[0:$fn-1]) let(a=i*delta) [R*cos(a)-R+diameter/2, R*sin(a)]];
	p = [[[0, 0]], curve, [[0, length]]];
	rotate_extrude() polygon(points=flatten(p));
}

module Missile(diameter=5.2, head=5, body=6.7)
{
	mov(z=body+0.5) Head(diameter=diameter, length=head);
	mov(z=2) cylinder(h=body, d=diameter-1);
	cylinder(h=body, d=diameter);
}

Missile();