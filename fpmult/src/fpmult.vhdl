library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.fpmult_comp.all;
use work.fpmult_stage0_comp.all;
use work.fpmult_stageN_comp.all;
use work.fpmult_stage23_comp.all;

entity fpmult is
	port(
		clk:in std_logic;

		a:in std_logic_vector(31 downto 0);
		b:in std_logic_vector(31 downto 0);
		p:out std_logic_vector(31 downto 0);

		p_s00:out std_logic_vector(23 downto 1);
		p_s01:out std_logic_vector(25 downto 1);
		p_s02:out std_logic_vector(26 downto 2);
		p_s03:out std_logic_vector(27 downto 3);
		p_s04:out std_logic_vector(28 downto 4);
		p_s05:out std_logic_vector(29 downto 5);
		p_s06:out std_logic_vector(30 downto 6);
		p_s07:out std_logic_vector(31 downto 7);
		p_s08:out std_logic_vector(32 downto 8);
		p_s09:out std_logic_vector(33 downto 9);
		p_s10:out std_logic_vector(34 downto 10);
		p_s11:out std_logic_vector(35 downto 11);
		p_s12:out std_logic_vector(36 downto 12);
		p_s13:out std_logic_vector(37 downto 13);
		p_s14:out std_logic_vector(38 downto 14);
		p_s15:out std_logic_vector(39 downto 15);
		p_s16:out std_logic_vector(40 downto 16);
		p_s17:out std_logic_vector(41 downto 17);
		p_s18:out std_logic_vector(42 downto 18);
		p_s19:out std_logic_vector(43 downto 19);
		p_s20:out std_logic_vector(44 downto 20);
		p_s21:out std_logic_vector(45 downto 21);
		p_s22:out std_logic_vector(46 downto 22)
	);
end;

architecture structural of fpmult is
	signal fpmult_stage0_in:fpmult_stage0_in_type;
	signal fpmult_stage0_out:fpmult_stage0_out_type;
	signal fpmult_stage23_in:fpmult_stage23_in_type;
	signal fpmult_stage23_out:fpmult_stage23_out_type;
	type fpmult_stageN_in_array_type is array(23 downto 1) of fpmult_stageN_in_type;
	type fpmult_stageN_out_array_type is array(22 downto 1) of fpmult_stageN_out_type;
	signal fpmult_stageN_in_array:fpmult_stageN_in_array_type;
	signal fpmult_stageN_out_array:fpmult_stageN_out_array_type;
begin
	fpmult_stage0_in.a<=a;
	fpmult_stage0_in.b<=b;

	stage0:fpmult_stage0 port map(clk,fpmult_stage0_in,fpmult_stage0_out);

	fpmult_stageN_in_array(1).a<=fpmult_stage0_out.a;
	fpmult_stageN_in_array(1).b<=fpmult_stage0_out.b;
	fpmult_stageN_in_array(1).p_sign<=fpmult_stage0_out.p_sign;
	fpmult_stageN_in_array(1).p_exp<=fpmult_stage0_out.p_exp;
	fpmult_stageN_in_array(1).p_mantissa<=fpmult_stage0_out.p_mantissa;
	
	pipeline:for N in 22 downto 1 generate
		stageN:fpmult_stageN generic map(N) port map(clk,fpmult_stageN_in_array(N),fpmult_stageN_out_array(N));
		fpmult_stageN_in_array(N+1)<=fpmult_stageN_out_array(N);
	end generate pipeline;

	fpmult_stage23_in.a<=fpmult_stageN_out_array(22).a;
	fpmult_stage23_in.p_sign<=fpmult_stageN_out_array(22).p_sign;
	fpmult_stage23_in.p_exp<=fpmult_stageN_out_array(22).p_exp;
	fpmult_stage23_in.p_mantissa<=fpmult_stageN_out_array(22).p_mantissa;

	stage23:fpmult_stage23 port map(clk,fpmult_stage23_in,fpmult_stage23_out);

	p<=fpmult_stage23_out.p;
	
	p_s00<=std_logic_vector(fpmult_stage0_out.p_mantissa(23 downto 1));
	p_s01<=std_logic_vector(fpmult_stageN_out_array(1).p_mantissa(25 downto 1));
	p_s02<=std_logic_vector(fpmult_stageN_out_array(2).p_mantissa(26 downto 2));
	p_s03<=std_logic_vector(fpmult_stageN_out_array(3).p_mantissa(27 downto 3));
	p_s04<=std_logic_vector(fpmult_stageN_out_array(4).p_mantissa(28 downto 4));
	p_s05<=std_logic_vector(fpmult_stageN_out_array(5).p_mantissa(29 downto 5));
	p_s06<=std_logic_vector(fpmult_stageN_out_array(6).p_mantissa(30 downto 6));
	p_s07<=std_logic_vector(fpmult_stageN_out_array(7).p_mantissa(31 downto 7));
	p_s08<=std_logic_vector(fpmult_stageN_out_array(8).p_mantissa(32 downto 8));
	p_s09<=std_logic_vector(fpmult_stageN_out_array(9).p_mantissa(33 downto 9));
	p_s10<=std_logic_vector(fpmult_stageN_out_array(10).p_mantissa(34 downto 10));
	p_s11<=std_logic_vector(fpmult_stageN_out_array(11).p_mantissa(35 downto 11));
	p_s12<=std_logic_vector(fpmult_stageN_out_array(12).p_mantissa(36 downto 12));
	p_s13<=std_logic_vector(fpmult_stageN_out_array(13).p_mantissa(37 downto 13));
	p_s14<=std_logic_vector(fpmult_stageN_out_array(14).p_mantissa(38 downto 14));
	p_s15<=std_logic_vector(fpmult_stageN_out_array(15).p_mantissa(39 downto 15));
	p_s16<=std_logic_vector(fpmult_stageN_out_array(16).p_mantissa(40 downto 16));
	p_s17<=std_logic_vector(fpmult_stageN_out_array(17).p_mantissa(41 downto 17));
	p_s18<=std_logic_vector(fpmult_stageN_out_array(18).p_mantissa(42 downto 18));
	p_s19<=std_logic_vector(fpmult_stageN_out_array(19).p_mantissa(43 downto 19));
	p_s20<=std_logic_vector(fpmult_stageN_out_array(20).p_mantissa(44 downto 20));
	p_s21<=std_logic_vector(fpmult_stageN_out_array(21).p_mantissa(45 downto 21));
	p_s22<=std_logic_vector(fpmult_stageN_out_array(22).p_mantissa(46 downto 22));
end;