library ieee;
use ieee.std_logic_1164.all;

package fpmult_generic is

subtype fp_status_type is std_logic_vector(2 downto 0);
constant ZERO:fp_status_type:="000";
constant NORMAL:fp_status_type:="001";
constant SUBNORMAL:fp_status_type:="010";
constant INFINITY:fp_status_type:="011";
constant NAN:fp_status_type:="100";
constant SIGNALLING_NAN:fp_status_type:="101";
constant QUIET_NAN:fp_status_type:="110";

-- type fp_status_type is (ZERO, NORMAL, INFINITY, NAN);

-- type fp_status_encoding_array_type is array(fp_status_type) of std_logic_vector(1 downto 0);

-- constant fp_status_encoding_array : fp_status_encoding_array_type := ( ZERO => "00", NORMAL => "01", INFINITY => "10", NAN => "11");

end package;