library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fp_generic.all;
use work.fpmult_stage0_comp.all;

entity fpmult_stage0 is
	port(
		clk:in std_logic;
		d:in fpmult_stage0_in_type;
		q:out fpmult_stage0_out_type
	);
end;

architecture twoproc of fpmult_stage0 is
	type reg_type is record
		a:fp_type;
		b:fp_type;

		p_sign:fp_sign_type;
		p_exp:fp_exp_type;
		p_mantissa:fp_long_mantissa_type;
	end record;
	signal r,rin:reg_type;
begin
	comb:process(d,r)
		variable v:reg_type;
		variable a_is_normal,b_is_normal:boolean;
		variable a_is_subnormal,b_is_subnormal:boolean;
		variable a_is_zero,b_is_zero:boolean;
		variable a_is_infinite,b_is_infinite:boolean;
		variable a_is_nan,b_is_nan:boolean;
		variable is_normal:boolean;
		variable is_zero:boolean;
		variable is_infinite:boolean;
		variable is_nan:boolean;
	begin
		-- sample register outputs
		v:=r;

		-- overload
		v.a:=d.a;
		v.b:=d.b;

		a_is_normal:=fp_is_normal(v.a);
		b_is_normal:=fp_is_normal(v.b);
		a_is_subnormal:=fp_is_subnormal(v.a);
		b_is_subnormal:=fp_is_subnormal(v.b);
		a_is_zero:=fp_is_zero(v.a);
		b_is_zero:=fp_is_zero(v.b);
		a_is_infinite:=fp_is_infinite(v.a);
		b_is_infinite:=fp_is_infinite(v.b);
		a_is_nan:=fp_is_nan(v.a);
		b_is_nan:=fp_is_nan(v.b);

		if a_is_normal or b_is_normal then
			if a_is_normal and b_is_normal then
				is_normal:=true;
			end if;
			if a_is_zero or b_is_zero then
				is_zero:=true;
			end if;
			if a_is_infinite or b_is_infinite then
				is_infinite:=true;
			end if;
			if a_is_nan or b_is_nan then
				is_nan:=true;
			end if;
		end if;
		
		v.p_sign:=fp_sign(d.a) xor fp_sign(d.b);
		v.p_exp:=fp_exp(d.a) + fp_exp(d.b) - 127;
		if fp_mantissa(d.b)(0)='1' then
			v.p_mantissa:=resize(fp_mantissa(d.a),48);
		else
			v.p_mantissa:=(others=>'0');
		end if;

		-- drive register inputs
		rin<=v;

		-- drive outputs
		q.a<=r.a;
		q.b<=r.b;

		q.p_sign<=r.p_sign;
		q.p_exp<=r.p_exp;
		q.p_mantissa<=r.p_mantissa;
	end process;
	
	seq:process(clk,rin)
	begin
		if rising_edge(clk) then
			r<=rin;
		end if;
	end process;
end;