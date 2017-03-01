-------------------------------------------------------------------------------
--                                                                           --
--  MT32 - Mersenne Twister                                                  --
--  Copyright (C) 2007 HT-LAB 												 --
--                                                                           --
--  Contact : Use feedback form on the website.					             --
--  Web: http://www.ht-lab.com												 --
--  																		 --
--  MT32 files are released under the GNU General Public License.            --
--                                                                           --
-------------------------------------------------------------------------------
--                                                                           --
--  This library is free software; you can redistribute it and/or            --
--  modify it under the terms of the GNU Lesser General Public               --
--  License as published by the Free Software Foundation; either             --
--  version 2.1 of the License, or (at your option) any later version.       --
--                                                                           --
--  This library is distributed in the hope that it will be useful,          --
--  but WITHOUT ANY WARRANTY; without even the implied warranty of           --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        --
--  Lesser General Public License for more details.                          --
--                                                                           --
--  Full details of the license can be found in the file "copying.txt".      --
--                                                                           --
--  You should have received a copy of the GNU Lesser General Public         --
--  License along with this library; if not, write to the Free Software      --
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA  --
--                                                                           --
-------------------------------------------------------------------------------
--                                                                           --
--  Top Level (Synthesis)                                                    --
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY mt_mem1 IS
   PORT( 
      clk    : IN     std_logic;
      ena    : IN     std_logic;
      resetn : IN     std_logic;
		dip_setting : IN std_logic_vector(7 downto 0);
      random : OUT    std_logic_vector (31 DOWNTO 0)
   );

END mt_mem1 ;

LIBRARY ieee;

ARCHITECTURE struct OF mt_mem1 IS

   -- Architecture declarations

   -- internal signal declarations
    signal kk_cnt  : std_logic_vector(9 downto 0);
    signal km_cnt  : std_logic_vector(9 downto 0);
    signal kp_cnt  : std_logic_vector(9 downto 0);
    signal mt_kk31 : std_logic_vector(0 downto 0);
    signal mt_kk_s : std_logic_vector(31 downto 0);
    signal mt_km   : std_logic_vector(31 downto 0);
    signal mt_kp   : std_logic_vector(30 downto 0);
    signal wea     : std_logic;
    signal wea_s   : std_logic_vector(0 downto 0);
    signal wr_cnt  : std_logic_vector(9 downto 0);


    signal xor1_s : std_logic_vector(31 downto 0);
    signal xor2_s : std_logic_vector(31 downto 0);
    signal xor3_s : std_logic_vector(31 downto 0);
    signal y_s : std_logic_vector(31 downto 0);
    signal mag01_s : std_logic_vector(31 downto 0);
	 
	 
   -- Component Declarations
   COMPONENT counters
   GENERIC (
      M : integer := 397;
      N : integer := 623
   );
   PORT (
      clk    : IN     std_logic ;
      resetn : IN     std_logic ;
      ena    : IN     std_logic ;
      wea    : OUT    std_logic ;
      kk_cnt : OUT    std_logic_vector (9 DOWNTO 0);
      km_cnt : OUT    std_logic_vector (9 DOWNTO 0);
      kp_cnt : OUT    std_logic_vector (9 DOWNTO 0);
      wr_cnt : OUT    std_logic_vector (9 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT dpram624x1_1
   PORT (
      addra : IN     std_logic_VECTOR (9 DOWNTO 0);
      addrb : IN     std_logic_VECTOR (9 DOWNTO 0);
      clka  : IN     std_logic;
      clkb  : IN     std_logic;
      dina  : IN     std_logic_VECTOR (0 DOWNTO 0);
      wea   : IN     std_logic_VECTOR (0 DOWNTO 0);
      doutb : OUT    std_logic_VECTOR (0 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT dpram624x31_1
   PORT (
      addra : IN     std_logic_VECTOR (9 DOWNTO 0);
      addrb : IN     std_logic_VECTOR (9 DOWNTO 0);
      clka  : IN     std_logic;
      clkb  : IN     std_logic;
      dina  : IN     std_logic_VECTOR (30 DOWNTO 0);
      wea   : IN     std_logic_VECTOR (0 DOWNTO 0);
      doutb : OUT    std_logic_VECTOR (30 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT dpram624x32_1
   PORT (
      addra : IN     std_logic_VECTOR (9 DOWNTO 0);
      addrb : IN     std_logic_VECTOR (9 DOWNTO 0);
      clka  : IN     std_logic;
      clkb  : IN     std_logic;
      dina  : IN     std_logic_VECTOR (31 DOWNTO 0);
      wea   : IN     std_logic_VECTOR (0 DOWNTO 0);
      doutb : OUT    std_logic_VECTOR (31 DOWNTO 0)
   );
   END COMPONENT;
	
    signal random_num : std_logic_vector(31 downto 0);  
    signal temp : std_logic_vector (7 downto 0);
BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   -- eb1 1                                        
   wea_s(0) <= wea; -- wonderful VHDL

   -- HDL Embedded Text Block 2 XOR_CHAIN1
   -- eb1 1     

   xor1_s <=  mt_kk_s  XOR ("00000000000"&mt_kk_s(31 downto 11));
   xor2_s <= xor1_s XOR (xor1_s(24 downto 0)&"0000000" AND X"9D2C5680");
   xor3_s <= xor2_s XOR (xor2_s(16 downto 0)&"000000000000000" AND X"EFC60000");
   random <= xor3_s XOR "000000000000000000"&xor3_s(31 downto 18);
     
--	process (clk,resetn) -- 
--begin
--    if  resetn ='0' then
--	 random_num<=(others=>'0');
--      elsif clk='1' and clk'event and (resetn = '1') then 
--	 -- make sure we get the default
--	  if random_num =    "00000000000000000000000000000000" then 
----	     random_num <=   "00000000000000010000000000000000";	   
----		  random_num <=   "00000000000000000000100000000000";
----        random_num <=   B"0000_0000_0000_0000_0000_0000_0100_0000";else
--         random_num(7 downto 0) <=   B"0000_0111";
--			else
--         random_num <= random_num - 1; --- gjk
--	  end if;
--   end if;
	--random<=random_num;
--end process; 	  
     --random <= random_num;

   -- HDL Embedded Text Block 3 eb3
   y_s <= mt_kk31(0)&mt_kp(30 downto 0);
   mag01_s <= X"00000000" when y_s(0)='0' else X"9908B0DF";
   mt_kk_s <= mt_km XOR ('0'&y_s(31 downto 1)) XOR mag01_s;


   -- Instance port mappings.
   U_7 : counters
      GENERIC MAP (
         M => 397,
         N => 623
      )
      PORT MAP (
         clk    => clk,
         resetn => resetn,
         ena    => ena,
         wea    => wea,
         kk_cnt => kk_cnt,
         km_cnt => km_cnt,
         kp_cnt => kp_cnt,
         wr_cnt => wr_cnt
      );
   U_0 : dpram624x1_1
      PORT MAP (
         clka  => clk,
         dina  => mt_kk_s(31 DOWNTO 31),
         addra => wr_cnt,
         wea   => wea_s,
         clkb  => clk,
         addrb => kk_cnt,
         doutb => mt_kk31
      );
   U_1 : dpram624x31_1
      PORT MAP (
         clka  => clk,
         dina  => mt_kk_s(30 DOWNTO 0),
         addra => wr_cnt,
         wea   => wea_s,
         clkb  => clk,
         addrb => kp_cnt,
         doutb => mt_kp
      );
   U_2 : dpram624x32_1
      PORT MAP (
         clka  => clk,
         dina  => mt_kk_s,
         addra => wr_cnt,
         wea   => wea_s,
         clkb  => clk,
         addrb => km_cnt,
         doutb => mt_km
      );

END struct;
