-- Created : andi klein
-- Date	  : 2/5/2017
-- this is the core of the RoadTest for the dark photon exchange
-- it uses a Mersenne twist random number generator
-- and provide output for submitting to the V1495


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package mystuff is
type diotype is array (0 to 8) of std_logic_vector(7 downto 0);
end mystuff;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL; 

--library LHC_lib;
--use LHC_lib.ALL;

library UNISIM;
use UNISIM.VComponents.all;

use work.mystuff.all;

entity RoadTest is
	generic(
			sta1_fib: integer :=80;
			sta2_fib: integer :=50;
			sta4_fib: integer :=32
			
			);
	
    Port ( 
         
           RST_IN : in  STD_LOGIC ;	 -- gets debounced through rst_debounce
			  sys_clk_in_pn	: in std_logic_vector(1 downto 0); -- LVDS system clock
			  -- 
			  FNAL_clock     : in std_logic; -- just in cases the clock is not LVDS




			PUSH_IN : in std_logic; --push button signal for single trigger
	      PUSH_STOP_in : in std_logic; --push button signal for stop
	      dip_switch: in std_logic_vector(7 downto 0);  -- these are the user dipwsitch, which can be set on the board
	 
	 
		-- the lvds output pairs
		 bank1_p: out std_logic_vector(31 downto 0); -- fisr LVDS pair of randoms
		 bank1_n: out std_logic_vector(31 downto 0);
		 bank2_p: out std_logic_vector(31 downto 0); -- fisr LVDS pair of randoms
		 bank2_n: out std_logic_vector(31 downto 0);
		 
		 DarkPhotonBank_p: out std_logic_vector(105 downto 0); -- the total output
		 DarkPhotonBank_n: out std_logic_vector(105 downto 0); -- the total output



			  
			  --- Differential 200 Mhz clock input
		 led_buff_ML605: out std_logic_vector(7 downto 0); -- The ML605 LEDs
		 led_buff_out:  out std_logic_vector(7 downto 0);
		 -- here we have the output lines
		 
		 line1:			out std_logic_vector(31 downto 0);
		 line2:			out std_logic_vector(31 downto 0);
		 line3:			out std_logic_vector(31 downto 0) );  -- end of port map
		 
		 --right now 96 lines
		 
		 
end RoadTest;

architecture Structural of RoadTest is



component signal_debounce
	 
    Port ( signal_in : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           signal_out : out  STD_LOGIC);
end component;

component mt_mem
	port (CLK :in  STD_LOGIC;
		   ena : in STD_LOGIC;
			resetn : in STD_LOGIC;
			dip_setting : in STD_LOGIC_VECTOR (7 downto 0);
			random : out std_logic_vector (31 downto 0)
			);
end component;	
 
component mt_mem1
	port (CLK :in  STD_LOGIC;
		   ena : in STD_LOGIC;  -- needs to be '1' to run
			resetn : in STD_LOGIC; -- needs to be '1' to run
			dip_setting : in STD_LOGIC_VECTOR (7 downto 0);
			random : out std_logic_vector (31 downto 0)
			);
end component;	
 
component data_synch
		port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           data_full : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out_v : in  STD_LOGIC;
           data_full_clk : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

component delay_counter is
    Port ( sig_in : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           sig_out : out  STD_LOGIC);
end component;













component andi_clock_core
port
 (-- Clock in ports
  CLK_IN1_P         : in     std_logic;
  CLK_IN1_N         : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic
  -- Status and control signals
  --RESET             : in     std_logic
  );
end component;

component decode is --- this decodes the track pattern into hits on station 1,2,4
	port (
	   rst : in  STD_LOGIC;
      clk : in  STD_LOGIC;
		ena : in std_logic ;
      hit_vector : in  STD_LOGIC_VECTOR (19 downto 0);
      quadrant : out  STD_LOGIC_VECTOR (3 downto 0);
      sta1 : out  STD_LOGIC_VECTOR (79 downto 0);
      sta2 : out  STD_LOGIC_VECTOR (49 downto 0);
      sta4 : out  STD_LOGIC_VECTOR (31 downto 0)
		);
end component;

component enable_reg is
    Port ( clk : in  STD_LOGIC;
           inp : in  STD_LOGIC;
           outp : out  STD_LOGIC);
end component;


-- component declarations for the Road Track ROMS

 COMPONENT road_quad0 IS
  PORT (
    ENA        : IN STD_LOGIC;  --opt port
    ADDRA      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    DOUTA      : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
	 CLKA       : IN STD_LOGIC );
  END COMPONENT;

 COMPONENT road_quad1 IS
  PORT (
    ENA        : IN STD_LOGIC;  --opt port
    ADDRA      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    DOUTA      : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
	 CLKA       : IN STD_LOGIC );
  END COMPONENT;

 COMPONENT road_quad2 IS
  PORT (
    ENA        : IN STD_LOGIC;  --opt port
    ADDRA      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    DOUTA      : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
	 CLKA       : IN STD_LOGIC );
  END COMPONENT;

 COMPONENT road_quad3 IS
  PORT (
    ENA        : IN STD_LOGIC;  --opt port
    ADDRA      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    DOUTA      : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
	 CLKA       : IN STD_LOGIC );
  END COMPONENT;
-- end road memory declaration



-- definitions for the two process satemachine

type state_type is (reset,waiting,running);
signal current_s, next_s: state_type;
-- end FSM definitions

signal clk_p : std_logic;
signal clk_n : std_logic;
signal clk_fast : std_logic; -- this is the clock signal produce by the lvds clock
--
signal clk_mst_out : std_logic; -- this is the clock used internally
-- to switch bewteen the clock the clk_mst_out assignment has to be witched between
-- clk_fast or FNAL_clock. Remeber to also siwthc this in the test bench


signal always_ena : std_logic;
signal always_ena_flip : std_logic; -- this is set on the moment alway_ena is set and stays on until

signal start_rnd : std_logic;
signal stop_rnd : std_logic;

signal init_rst : std_logic;
signal not_rst : std_logic;

signal dip_switch_signal: std_logic_vector(7 downto 0); --lowest 3 bits used for rdn cycle
signal random_bus :std_logic_vector(31 downto 0);
signal random_bus1 :std_logic_vector(31 downto 0);

constant maxcount : natural := 4800000;
--constant maxcount : natural := 20; -- change to above for real running
signal clock_led : std_logic ; -- signal of clock in rougly one second on LED

signal rnd_interval : integer ; -- how many clock cycles before next rnd

-- next signal is for the random number frequency
-- it takes the lowest three bits of the switc setting
signal rnd_freq: std_logic_vector(2 downto 0);

-- debounced switch signals
signal d_rst : std_logic;
signal d_push_start : std_logic;
signal d_push_stop : std_logic;

-- the tracknumber for the different quadrants for the LUT
constant road_count_quad0 : natural := 1376 ;
constant road_count_quad1 : natural := 1412 ;
constant road_count_quad2 : natural := 1378 ;
constant road_count_quad3 : natural := 1414 ;

-- the track number is the number of a valid track stored in the ROM
signal track_number0 : std_logic_vector(10 downto 0);
signal track_number1 : std_logic_vector(10 downto 0);
signal track_number2 : std_logic_vector(10 downto 0);
signal track_number3 : std_logic_vector(10 downto 0);

-- the counter for the track number, everytime we have an enable we augment the track number by one
signal track_counter : natural range 0 to 1500;
-- the hit vector is the content of the memory address in the rom
-- and is defined as
-- (hit_vector 19 downto 18) : quadrant number
-- (hit_vector 17 downto 11) : number of station 1 scintillator fired
-- (hit_vector 10 downto 5) : number of station 2 scintillator fired
-- (hit_vector 4 downto 0) : number of station 4 scintillator fired
signal hit_vector0 : std_logic_vector(19 downto 0);
signal hit_vector1 : std_logic_vector(19 downto 0);
signal hit_vector2 : std_logic_vector(19 downto 0);
signal hit_vector3 : std_logic_vector(19 downto 0);
signal hit_vector0_t : std_logic_vector(19 downto 0);
signal hit_vector1_t : std_logic_vector(19 downto 0);
signal hit_vector2_t : std_logic_vector(19 downto 0);
signal hit_vector3_t : std_logic_vector(19 downto 0);

-- decoded signals
signal decode_quadrant :   STD_LOGIC_VECTOR (3 downto 0);
signal decode_sta1_0 :   STD_LOGIC_VECTOR (sta1_fib-1 downto 0);
signal decode_sta2_0 :   STD_LOGIC_VECTOR (sta2_fib-1 downto 0);
signal decode_sta4_0 :   STD_LOGIC_VECTOR (sta4_fib-1 downto 0);

signal decode_sta1_1 :   STD_LOGIC_VECTOR (sta1_fib-1 downto 0);
signal decode_sta2_1 :   STD_LOGIC_VECTOR (sta2_fib-1 downto 0);
signal decode_sta4_1 :   STD_LOGIC_VECTOR (sta4_fib-1 downto 0);

signal decode_sta1_2 :   STD_LOGIC_VECTOR (sta1_fib-1 downto 0);
signal decode_sta2_2 :   STD_LOGIC_VECTOR (sta2_fib-1 downto 0);
signal decode_sta4_2 :   STD_LOGIC_VECTOR (sta4_fib-1 downto 0);

signal decode_sta1_3 :   STD_LOGIC_VECTOR (sta1_fib-1 downto 0);
signal decode_sta2_3 :   STD_LOGIC_VECTOR (sta2_fib-1 downto 0);
signal decode_sta4_3 :   STD_LOGIC_VECTOR (sta4_fib-1 downto 0);

signal enable_decode : std_logic; -- takes care of the del;ay from reading the rom of one clock


signal DarkPhotonBank : std_logic_vector (105 downto 0); -- decoded tracks (without qudarant info)
signal QuadSelector : std_logic_vector(1 downto 0); -- selects quadrant from dipswitch

begin
 




dip_switch_signal(7 downto 0)<= dip_switch(7 downto 0);
CLK_N <= sys_clk_in_pn(0); 
CLK_P <= sys_clk_in_pn(1);


start_rnd <= d_push_start;
stop_rnd <= d_push_stop; 

line1<=random_bus;
line2<=random_bus1;

-- here is the clock assignment
clk_mst_out<=Fnal_clock;
--clk_mst_out<=clk_fast;

-- assign dipswitch to values
rnd_freq<=dip_switch(2 downto 0);
QuadSelector<=dip_switch(7 downto 6);
track_number0 <=conv_std_logic_vector(track_counter,11);


rnd_interval <= (conv_integer(rnd_freq)+1)*100; -- this way we ensure no 0

-- assign the sations to darkphotonbank
-- currently we use 50 bits sta1
--						  40 bits  sta2
--							8 bits sta4

DarkPhotonBank(7 downto 0) <= decode_sta4_0( 7 downto 0);
DarkPhotonBank(47 downto 8) <= decode_sta2_0(39 downto 0);
DarkPhotonBank(97 downto 48) <= decode_sta1_0(49 downto 0);



 Inst_mt_mem : mt_mem
	port map (		
		clk => CLK_mst_out,

		resetn => NOT_RST,
		ena => always_ena,
		dip_setting =>dip_switch_signal,
		random => random_bus
		);

 Inst_mt_mem1 : mt_mem1
	port map (		
		clk => CLK_mst_out,

		resetn => NOT_RST,
		ena => always_ena,
		dip_setting =>dip_switch_signal,
		random => random_bus1
		);

 






				 


debounce0 : signal_debounce 
    Port map ( signal_in =>rst_in,
           clk =>clk_mst_out,
           signal_out =>d_rst);

debounce1 : signal_debounce 
    Port map ( signal_in =>push_stop_in,
           clk =>clk_mst_out,
           signal_out =>d_push_stop);

debounce2 : signal_debounce 
    Port map ( signal_in =>push_in,
           clk =>clk_mst_out,
           signal_out =>d_push_start);


-- begin roda rom instatiation

r0 : road_quad0
    Port map (
    ENA   => always_ena,
    ADDRA => track_number0,
 --   ADDRA => conv_std_logic_vector(track_counter,11),
    DOUTA => hit_vector0,
	 CLKA  => clk_mst_out );


r1 : road_quad1
    Port map (
    ENA   => always_ena,
    ADDRA => track_number1,
    DOUTA => hit_vector1,
	 CLKA  => clk_mst_out );


r2 : road_quad2
    Port map (
    ENA   => always_ena,
    ADDRA => track_number2,
    DOUTA => hit_vector2,
	 CLKA  => clk_mst_out );


r3 : road_quad3
    Port map (
    ENA   => always_ena,
    ADDRA => track_number0,
    DOUTA => hit_vector3,
	 CLKA  => clk_mst_out );

dec0 : decode
	 Port map (
		rst => d_rst,
           clk => clk_mst_out,
			  --ena => enable_decode , -- takes care of the delay from the LUT
			  ena => always_ena , -- takes care of the delay from the LUT
           hit_vector => hit_vector0_t,
           quadrant => decode_quadrant,
           sta1 => decode_sta1_0,
           sta2 => decode_sta2_0,
           sta4 => decode_sta4_0);
	 
dec1 : decode
	 Port map (
		rst => d_rst,
           clk => clk_mst_out,
			  ena => always_ena , -- takes care of the delay from the LUT
           hit_vector => hit_vector1_t,
           quadrant => decode_quadrant,
           sta1 => decode_sta1_1,
           sta2 => decode_sta2_1,
           sta4 => decode_sta4_1);


dec2 : decode
	 Port map (
		rst => d_rst,
           clk => clk_mst_out,
			  ena => always_ena , -- takes care of the delay from the LUT
           hit_vector => hit_vector2_t,
           quadrant => decode_quadrant,
           sta1 => decode_sta1_2,
           sta2 => decode_sta2_2,
           sta4 => decode_sta4_2);


dec3 : decode
	 Port map (
		rst => d_rst,
           clk => clk_mst_out,
			  ena => always_ena , -- takes care of the delay from the LUT
           hit_vector => hit_vector3_t,
           quadrant => decode_quadrant,
           sta1 => decode_sta1_3,
           sta2 => decode_sta2_3,
           sta4 => decode_sta4_3);






	 
--uncomment for internal clock	 
INST_ANDI_CLOCK_CORE : andi_clock_core
  port map
   (-- Clock in ports
    CLK_IN1_P          => CLK_P,
    CLK_IN1_N          => CLK_N,
    -- Clock out ports
    CLK_OUT1           => CLK_FAST);
    -- Status and control signals
    --RESET              => RST_in);




--comment for internal clock
--uncomment for lvds clock at LANL
--LHC_clk: IBUFDS
--	       port map (
--			 I=>CLK_P,
--			 IB=>CLK_N,
--			 O=>CLK_MST_OUT);

--Comment for LVDS clock or internal clock CERN
--CLK_MST_OUT<=CLK_NIM;


Ena_reg : enable_reg
    Port map( clk =>clk_mst_out,
           inp =>always_ena,
           outp =>enable_decode);


	 
	 





-- here we generate the output lvds signals
ogen1: for j in 0 to 31 generate
		DS: OBUFDS
		port map (
			O => bank1_p(j),
			OB => bank1_n(j),
			I => random_bus(j));
		DS1: OBUFDS
				port map (
			O => bank2_p(j),
			OB => bank2_n(j),
			I => random_bus1(j));

end generate;

DarkBank : for j in 0 to 100 generate
		 DS2: OBUFDS
		port map (
			O => DarkPhotonBank_p(j),
			OB => DarkPhotonBank_n(j),
			I => DarkPhotonBank(j));
end generate;

rndprocess : process(clk_mst_out, d_rst) -- this is the driver for the random number generator
   variable counter : natural range 0 to maxcount;
   variable counter1 : natural range 0 to maxcount;
   begin
	if(d_rst = '1') then
	  counter := 0;
	  always_ena<='0';
	  always_ena_flip<='0';
	  track_counter<=0;
	  		 hit_vector0_t<=(others=>'0');
			 hit_vector1_t<=(others=>'0');
			 hit_vector2_t<=(others=>'0');
			 hit_vector3_t<=(others=>'0');

	  
	 elsif clk_mst_out'event and clk_mst_out ='1' then
	 -- reset track counter, currently only implemented for quad 0
	  if track_counter = (road_count_quad0-2) then
	    track_counter <=0;
		end if; 
	    if counter = rnd_interval and not_rst = '1' then
		   always_ena<='1' ; -- enable randum numbers (and with the start stop condition
 			 counter := 0; -- reset counter
          track_counter<= track_counter+2; -- this is done since every second track is identical with the first one, but has station 4 going 16 -31
			 hit_vector0_t<=hit_vector0;
			 hit_vector1_t<=hit_vector1;
			 hit_vector2_t<=hit_vector2;
			 hit_vector3_t<=hit_vector3;
		 else
		   always_ena<='0';
			counter := counter+1;
			 hit_vector0_t<=(others=>'0');
			 hit_vector1_t<=(others=>'0');
			 hit_vector2_t<=(others=>'0');
			 hit_vector3_t<=(others=>'0');

		 end if;
		 
	 end if;
	
end process rndprocess;		 

lightled: process (clk_mst_out, d_rst) -- make s the led liight up
variable counter_led : natural range 0 to maxcount;
	begin
		if(d_rst = '1') then
	  counter_led := 0;
	  clock_led<='0';
	 elsif clk_mst_out'event and clk_mst_out ='1' then
      if counter_led < maxcount/2 then
		  counter_led := counter_led+1;
		  clock_led <= '1';
		elsif  counter_led  < maxcount then
		  counter_led := counter_led+1;
		  clock_led <= '0';
      else -- we hit the end
		   clock_led <= '1';
			counter_led := 0;
		end if;
     end if;
end process lightled;	  
 
-- here are the two processes controlling the FSM
FSM_SYNCH :process(clk_mst_out,d_rst)
	begin
		if(d_rst = '1') then
			current_s <= reset;
		
		elsif(clk_mst_out'event and clk_mst_out = '1') then
			current_s <= next_s;
		end if;
	end process FSM_SYNCH;
	
FSM_COMB : process(current_s,d_push_start, d_push_stop, d_rst)
	begin
	
	case current_s is
		when reset =>
		-- reset the LEDs
		LED_BUFF_ML605 <= (others=>'0');
		next_s<= waiting;
		
		when waiting =>
			not_rst<='0';
			LED_BUFF_ML605(1)<=not_rst;

			if d_push_start = '1' then
			   not_rst<='1';

				next_s <= running;
			elsif d_rst ='1' then
				next_s <= reset;
			else
				next_s <= waiting;
			end if;
		when  running =>
			LED_BUFF_ML605(5 downto 2)<=random_bus(5 downto 2);
			LED_BUFF_ML605(0)<=always_ena;
			LED_BUFF_ML605(1)<=not_rst;

			LED_BUFF_ML605(6)<=push_in;  -- to figurte out if high or low light up
			LED_BUFF_ML605(7)<=clock_led;

		   
			if d_push_stop = '1' then
				next_s <= waiting;
			elsif d_rst ='1' then
				next_s <= reset;
			else
				next_s <=running;
			end if;
	 end case;
 end process FSM_COMB;
				
		
		
		




end Structural;

