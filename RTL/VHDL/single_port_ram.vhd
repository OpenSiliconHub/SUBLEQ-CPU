library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity single_port_ram is
  generic (
    G_DATA_WIDTH : natural := 16;
    G_ADDR_WIDTH : natural := 16
    --G_INIT_MEM   : string  := "mem_init.hex"
  );
  port (
    i_clk  : in  std_logic;
    i_we   : in  std_logic;
    i_addr : in  std_logic_vector(G_ADDR_WIDTH - 1 downto 0);
    i_data : in  std_logic_vector(G_DATA_WIDTH - 1 downto 0);
    o_data : out std_logic_vector(G_DATA_WIDTH - 1 downto 0)
  );
end entity;

architecture rtl of single_port_ram is
  ----------------------------------------------------------------------------------------------------------------------
  -- mem_proc
  type ram_array_t is array (0 to (2 ** G_ADDR_WIDTH) - 1) of std_logic_vector(G_DATA_WIDTH - 1 downto 0);
  signal ram_block : ram_array_t := (others => (others => '0'));
  ----------------------------------------------------------------------------------------------------------------------
  -- Function to preload memory from file
  -- impure function init_ram_f(
  --   i_filename : in string
  -- ) return ram_array_t is
  --
  --   file mem_file      : text open read_mode is i_filename;
  --   variable mem_line  : line;
  --   variable mem_value : ram_array_t;
  --
  -- begin
  --
  --   for ii in ram_array_t'range loop
  --     if (not endfile(mem_file)) then
  --       readline(mem_file, mem_line);
  --       hread(mem_line, mem_value(ii));
  --     else
  --       mem_value(ii) := (others => '0');
  --     end if;
  --   end loop;
  --
  --   return mem_value;
  -- end function;
  -- -------------------------------------------------------------------------------------------------------------------
  -- -- Assign ram_block
  -- signal ram_block : ram_array_t := init_ram_f(G_INIT_MEM);

begin

  ----------------------------------------------------------------------------------------------------------------------
  -- mem_proc
  -- Always output data from i_addr
  mem_proc : process(i_clk) is
  begin
    if (rising_edge(i_clk)) then
      if (i_we = '1') then
        ram_block(to_integer(unsigned(i_addr))) <= i_data;
      end if;

      o_data <= ram_block(to_integer(unsigned(i_addr)));

    end if;

  end process;

end;
