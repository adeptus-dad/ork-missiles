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

module Fins(n=4, size=4)
{
	p = [[0, 1], [size, 1], [size, size/2], [size/2, size], [0, size], [0, 1]];
	echo(p);
	for (i=[0:n]) rot(i*360/n) 
		linear_extrude(height = 1, center = true) polygon(points=p, convexity = 1);
}


module Missile(diameter=5.2, head=5, body=6.7, fin_size=4, fin_n=4)
{
	mov(z=body+fin_size+1) Head(diameter=diameter, length=head);
	mov(z=fin_size+2.5) cylinder(h=body, d=diameter-1);
	mov(z=fin_size+0.5) cylinder(h=body, d=diameter);
	difference()
	{
		cylinder(h=fin_size+2, d=3);
		mov(z=-1) cylinder(h=fin_size+2, d=1);		
	}
	rot(y=-90) Fins(n=fin_n, size=fin_size);
}

Missile(fin_n=3);