----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:45:44 08/23/2011 
-- Design Name: 
-- Module Name:    global_rst - Behavioral 
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

entity global_rst is
    Port ( hard_reset : in  STD_LOGIC;
	        clk : in std_logic;
           system_reset : in  STD_LOGIC;
           reset : out  STD_LOGIC);
end global_rst;

architecture Behavioral of global_rst is
signal temp : std_logic;
begin

 process(clk,hard_reset,system_reset)
   begin
      if (clk='1' and clk'event) then	  	
		  if(hard_reset = '1') or system_reset = '1' then
		   temp<='1';
		  else
		   temp<='0';
		  end if;
		 end if;
 end process;
 
 reset<= temp;



end Behavioral;

