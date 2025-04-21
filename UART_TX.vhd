library ieee;
use ieee.std_logic_1164.all; 

entity UART_TX is
port ( 
	clk : in std_logic ;
	tx  : out std_logic ;
	data:in std_logic_vector(7 downto 0);
	start:in std_logic 
	);
 end UART_TX;
architecture UART_TX1 of UART_TX is

	type state is (idle, start_bit, data_bit, stop_bit,delay);
	
	signal data_temp : std_logic_vector(7 downto 0);
	signal s : state := idle;
	
	

Begin
 process(clk)
		variable dem_uart : integer range 0 to 5000001 :=0;
		variable count : integer := 0;
		variable i : integer range 0 to 10 := 0;
		--variable demuart: integer range 0 to 100000001 := 0;
	begin

		if(rising_edge (clk)) then
			if(dem_uart <= 0)then 
				
				
			case s is
			when idle =>
							TX <= '1';
							count := 0;
							i := 0;
						
							if( start= '0') then
								s <= start_bit;
							end if;
			when start_bit =>
							TX <= '0';
							count := count + 1;
							
							if (count >= 5200 ) then
								s <= data_bit;
								count := 0;
							end if;
			when data_bit =>
							TX <= data(i);
							count := count + 1;
						
							if(count >= 5200) then
								i := i + 1;
								count := 0;
							end if;
							if (i>=8) then
								i := 0;
								count := 0;
								s <= stop_bit;
							end if;
			when stop_bit =>
							TX <= '1';
							if(count < 5200) then	
								count := count + 1;
								
							end if;
							if (count >= 5200) then
								s <= idle;
								count := 0;
								
							end if;
							
			when others =>
			dem_uart:=5000000;
			end case;
			end if;
			dem_uart := dem_uart-1 ;
			
		end if;
					
end process;
end UART_TX1;