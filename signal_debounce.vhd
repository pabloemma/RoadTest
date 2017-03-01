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

entity signal_debounce is
    Port ( signal_in : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           signal_out : out  STD_LOGIC);
end signal_debounce;





architecture Behavioral of signal_debounce is
  type State_Type is (S0, S1);
  signal State : State_Type := S0;

  signal DPB, SPB : STD_LOGIC;
  signal DReg : STD_LOGIC_VECTOR (7 downto 0);
begin
  process (CLK, signal_in)
    variable SDC : integer;
    constant Delay : integer := 50000;  -- debounce length is delay* clock freq
    --constant Delay : integer := 5;
  begin
    if CLK'Event and CLK = '1' then
      -- Double latch input signal
      DPB <= SPB;
      SPB <= signal_in;

      case State is
        when S0 =>
          DReg <= DReg(6 downto 0) & DPB;

          SDC := Delay;

          State <= S1;
        when S1 =>
          SDC := SDC - 1;

          if SDC = 0 then
            State <= S0;
          end if;
        when others =>
          State <= S0;
      end case;

      if DReg = X"FF" then
        signal_out <= '1';
      elsif DReg = X"00" then
        signal_out <= '0';
      end if;
    end if;
  end process;
end Behavioral;