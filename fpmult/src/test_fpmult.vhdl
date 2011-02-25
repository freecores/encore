library ieee;
use ieee.std_logic_1164.all;
use work.fp_generic.all;
use work.fpmult_comp.all;

entity test_fpmult is
end;

architecture testbench of test_fpmult is
	signal clk:std_logic:='0';
	signal d:fpmult_in_type;
	signal q:fpmult_out_type;
begin

	dut:fpmult port map(clk,d,q);

	clock:process
	begin
	   wait for 10 ns; clk  <= not clk;
	end process clock;

	stimulus:process
	begin
	  d.a<="00111111110110010100011101010101";  -- 0x3FD94755 -> 1.69748938
	  d.b<="00111111101101110110110011100001";  -- 0x3FB76CE1 -> 1.43301022
    wait;
	end process stimulus;

end testbench;

