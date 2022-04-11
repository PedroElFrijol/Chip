library ieee;
use ieee.std_logic_1164.all;

entity tb_cpu is
	port (clock:	in	std_logic;
	      reset:	in	std_logic
	);
end;

architecture main of tb_cpu is

component CPU8BIT is
    --std_logic_vector defines a vector of elements of type std_logic
    port(   data:    inout std_logic_vector(7 downto 0); --decending from 7 to 0
            address: out std_logic_vector(5 downto 0);
            oe:      out std_logic; --output enable signal and read data is output from a data pin when it is set at low level
            we:      out std_logic; --write enabled is enabled when "we" is set at low level
            reset:   in  std_logic;
            clock:   in  std_logic);
end component;