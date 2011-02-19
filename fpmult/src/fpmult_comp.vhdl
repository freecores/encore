library ieee;
use ieee.std_logic_1164.all;

package fpmult_comp is
	type fpmult_in_type is record
		a:std_logic_vector(22 downto 0);
		b:std_logic_vector(22 downto 0);
	end record;

	type fpmult_out_type is record
		p:std_logic_vector(22 downto 0);
	end record;

	component fpmult is
		port(
			clk:in std_logic;
			d:in fpmult_in_type;
			q:out fpmult_out_type
		);
	end component;
end package;