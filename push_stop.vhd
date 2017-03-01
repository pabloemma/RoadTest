----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:22:34 06/14/2011 
-- Design Name: 
-- Module Name:    push_stop - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity push_stop is
generic (max_count : integer:= 100000000); --max_count times 25 ns gives time of block for input push


    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           push : in  STD_LOGIC;
           state : out  STD_LOGIC);
end push_stop;

architecture Behavioral of push_stop is

signal temp : std_logic;
signal state_out : std_logic;
signal counter : integer range 0 to max_count;

begin

process(RST)
--process(CLK,RST)
begin
	if RST ='1' then 
	state_out<='0';
	temp<='0';
	counter <= 0;
	
	else
	if (counter =0) then
	   if push ='1'  then 
		  state_out <='1'; -- hopefully stays up
		  counter<=counter+1;
		  end if;
	 end if;



		 
	end if;
end process;

state<=state_out;

end Behavioral;

