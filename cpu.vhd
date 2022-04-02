library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity CPU8BIT is
    --std_logic_vector defines a vector of elements of type std_logic
    port(   data:    inout std_logic_vector(7 downto 0); --decending from 7 to 0
            address: out std_logic_vector(5 downto 0);
            oe:      out std_logic; --output enable signal and read data is output from a data pin when it is set at low level
            we:      out std_logic; --write enabled is enabled when "we" is set at low level
            reset:   in  std_logic;
            clock:   in  std_logic);
end;

--carries the data between the processor and other components
architecure CPUArch of CPU8BIT is
    signal accumulator: std_logic_vector(8 downto 0); --wires that denote the communication channels between concurrent statements, The 9-th bit is the "carry flag"
    signal addressRegister: std logic vector (5 downto 0); --address register
    signal prgmCount: std logic vector (5 downto 0); --program counter
    signal states : std logic vector (2 downto 0);

begin 
    process(clock, reset)
    begin
        if(reset = "0") then
            addressRegister <= (others => "0"); --start executing at memory location 0
            states <="000";
            accumulator <= (others => "0");
            prgmCount <= (others => "0");
        elsif rising_edge(clock) then --It will return true when the signal changes from a low value ('0' or 'L') to a high value ('1' or 'H'). 
            --Address Path/ Program Counter
            if (states = "000") then
                prgmCount <= addressRegister + 1; --increment bit by 1
                addressRegister <= data (5 downto 0);
            else
                addressRegister <= prgmCount;
            end if;
        
        --ALU/ Data Path
        case states is -- looks at each possible condition to find one that the input signal satisfies
            when "010" => accumulator <= ("0" & accumulator(7 downto 0)) + ("0" & data); --add, accumulator = accumulator + mem[AAAAAA], update carry
            when "011" => accumulator(7 downto 0) <= accumulator(7 downto 0) nor data; --nor, accumulator = accumulator NOR mem[AAAAAA]
            when "101" => accumulator(8) <="0"; --branch not taken, clear carry
            when others => null; --instruction fetch, jcc taken (000), sta (001)
        end case;

        --Control or State Machine
        if ( states /= "000") then states <= "000"; --fetch next opcode
        elsif (data(7 downto 6) = "11" and akku(8) = "1") then states <= "101"; --branch n. taken
            else states <= "0" & not data(7 downto 6); --execute instruction
        end if;
    end process;

    --Output
    address <= addressRegister; --forward addressRegister computation result to actual address used for next clock
    data <= "ZZZZZZZZ" when states /= "001" else accumulator(7 downto 0); --means don't "drive" the signal, let another circuit drive it (and you can use it as input).
    oe <= "1" when (clock = "1" or states = "001" or reset = "0" or states = "101") else "0"; --Set "output enable" pin of static RAM on memory cycles
    --no memory access during reset
    we <= "1" when (clock = "1" or states /= "001" or reset = "0") else "0"; --Set RAM to read except for store instruction (when not resetting)
    --state ”101” (branch not taken)