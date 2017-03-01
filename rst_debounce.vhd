----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:11:35 08/30/2010 
-- Design Name: 
-- Module Name:    rst_debounce - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rst_debounce is
    Port ( RST_IN_DEB : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst_deb : out  STD_LOGIC);
end rst_debounce;

architecture Behavioral of rst_debounce is

constant max_scale : integer :=7;
signal prescaler : integer range 0 to max_scale;
signal inputsr   : std_logic_vector(2 downto 0);
begin
   process(clk)
  	 begin
      if clk'event and clk ='1' then 
   if (prescaler=0) then
      prescaler <= max_scale; -- shuold be something longer. the debounce is 4 times the prescaler value in ns
   
      if (inputsr = "000") then rst_deb<='0'; end if;
      if (inputsr = "100") then rst_deb<='1'; end if;
       inputsr <= inputsr(1 downto 0) & RST_IN_DEB;
   else
      prescaler <= prescaler-1;
   end if;
	   rst_deb<=rst_in_deb;
		end if;
   end process;

end Behavioral;

