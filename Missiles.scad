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
	p = [[0, 1], [size, 1], [size, size/4+1], [size/2, size+1], [0, size+1], [0, 1]];
	for (i=[0:n]) rot(i*360/n) 
		linear_extrude(height = 1, center = true) polygon(points=p, convexity = 1);
}

module RivetsPos(n=6, body=6.7, fin_size=4, invert=false, percent=75)
{
	delta = 360/n;
	pos = [fin_size+0.5+1, fin_size+body+0.5-1];
	for(h=pos) mov(z=h) for (a=[0:delta:359]) 
	{
		r=rands(min_value=0, max_value=100, value_count=1, seed_value=a*body*h*1000)[0];
		doit = r<percent; 
		if(invert?!doit:doit) rot(z=a) rot(x=90) children(0);
	}	
}

module Missile(diameter=5.2, head=5, body=6.7, fin_size=4, fin_n=4)
{
	mov(z=body+fin_size+1) Head(diameter=diameter, length=head);
	mov(z=fin_size+2.5) cylinder(h=body, d=diameter-1);
	difference()
	{
		mov(z=fin_size+0.5) cylinder(h=body, d=diameter);
		RivetsPos(n=round(diameter*1.5), body=body, fin_size=fin_size, invert=true) 
			cylinder(h=diameter/2+0.4, d=0.6, $fn=10);
	}
	RivetsPos(n=round(diameter*1.5), body=body, fin_size=fin_size) 
		cylinder(h=diameter/2+0.3, d=0.8, $fn=6);
	difference()
	{
		cylinder(h=fin_size+2, d=3);
		mov(z=-1) cylinder(h=fin_size+2, d=1);		
	}
	rot(y=-90) Fins(n=fin_n, size=fin_size);
}

module RandomMissile(seed=1)
{
	d = rands(min_value=3.5, max_value=6.5, value_count=1, seed_value=seed+100)[0];
	h = rands(min_value=d, max_value=d+2, value_count=1, seed_value=seed+101)[0];
	b = rands(min_value=h-1, max_value=h+2, value_count=1, seed_value=seed+102)[0];
	f = rands(min_value=d-2, max_value=3, value_count=1, seed_value=seed+102)[0];
	n = rands(min_value=3, max_value=4,   value_count=1, seed_value=seed+102)[0];
	Missile(diameter=d, head=h, body=b, fin_size=f, fin_n=round(n));
}

Missile();
for (a=[1:10]) mov(x=a*10) RandomMissile(seed=a+123135);
