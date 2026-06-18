library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity subleq is
  generic (
    G_RESET_ACTIVE_STATE : std_logic := '0';
    G_DATA_WIDTH         : natural   := 16;
    G_ADDR_WIDTH         : natural   := G_DATA_WIDTH
  );
  port (
    i_clk      : in  std_logic;
    i_rst_n    : in  std_logic;
    o_pc_debug : out std_logic_vector(G_ADDR_WIDTH - 1 downto 0)
  );
end entity;

architecture rtl of subleq is
  ----------------------------------------------------------------------------------------------------------------------
  -- u_single_port_ram
  signal mem_data : std_logic_vector(G_DATA_WIDTH - 1 downto 0);
  ----------------------------------------------------------------------------------------------------------------------
  -- subleq_proc
  type subleq_sm_t is (
    SUBLEQ_RESET,
    SUBLEQ_FETCH_A,
    SUBLEQ_FETCH_B,
    SUBLEQ_FETCH_C,
    SUBLEQ_FETCH_DATA_A,
    SUBLEQ_FETCH_DATA_B,
    SUBLEQ_SUBTRACT,
    SUBLEQ_WRITEBACK,
    SUBLEQ_BRANCH_CHECK
  );
  signal subleq_sm   : subleq_sm_t                                 := SUBLEQ_RESET;
  signal pc          : std_logic_vector(G_ADDR_WIDTH - 1 downto 0) := (others => '0');
  signal ir_a        : std_logic_vector(G_ADDR_WIDTH - 1 downto 0) := (others => '0');
  signal ir_b        : std_logic_vector(G_ADDR_WIDTH - 1 downto 0) := (others => '0');
  signal ir_c        : std_logic_vector(G_ADDR_WIDTH - 1 downto 0) := (others => '0');
  signal data_a      : std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal data_b      : std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal subleq_we   : std_logic                                   := '0';
  signal subleq_addr : std_logic_vector(G_ADDR_WIDTH - 1 downto 0) := (others => '0');
  signal subleq_data : std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');

begin

  ----------------------------------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------------------------------
  -- memory
  u_single_port_ram : entity work.single_port_ram
    generic map (
      G_DATA_WIDTH => G_DATA_WIDTH,
      G_ADDR_WIDTH => G_ADDR_WIDTH
    )
    port map (
      i_clk  => i_clk,
      i_we   => subleq_we,
      i_addr => subleq_addr,
      i_data => subleq_data,
      o_data => mem_data
    );

  -------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------
  -- subleq_proc
  --
  o_pc_debug <= pc;
  subleq_proc : process (i_clk) is
  begin
    if (rising_edge(i_clk)) then
      if (i_rst_n = G_RESET_ACTIVE_STATE) then
        subleq_sm <= SUBLEQ_RESET;
        pc        <= (others => '0');
      else
        subleq_we <= '0';

        case subleq_sm is
          when SUBLEQ_RESET =>
            ------------------------------------------------------------------------------------------------------------
            -- SUBLEQ_RESET
            -- Default state
            pc        <= (others => '0');
            subleq_sm <= SUBLEQ_FETCH_A;

          when SUBLEQ_FETCH_A =>
            ------------------------------------------------------------------------------------------------------------
            -- SUBLEQ_FETCH_A
            -- Get address A
            subleq_addr <= pc;
            subleq_sm   <= SUBLEQ_FETCH_B;

          when SUBLEQ_FETCH_B =>
            ------------------------------------------------------------------------------------------------------------
            -- SUBLEQ_FETCH_B
            -- Get address B
            -- Capture data from address A
            subleq_addr <= std_logic_vector(unsigned(pc) + 1);
            ir_a        <= mem_data;
            subleq_sm   <= SUBLEQ_FETCH_C;

          when SUBLEQ_FETCH_C =>
            ------------------------------------------------------------------------------------------------------------
            -- SUBLEQ_FETCH_C
            -- Get address C
            -- Capture data from address B
            subleq_addr <= std_logic_vector(unsigned(pc) + 2);
            ir_b        <= mem_data;
            subleq_sm   <= SUBLEQ_FETCH_DATA_A;

          when SUBLEQ_FETCH_DATA_A =>
            ------------------------------------------------------------------------------------------------------------
            -- SUBLEQ_FETCH_DATA_A
            -- Get stored data from memory address data_a
            -- Capture data from address C
            subleq_addr <= ir_a;
            ir_c        <= mem_data;
            subleq_sm   <= SUBLEQ_FETCH_DATA_B;

          when SUBLEQ_FETCH_DATA_B =>
            ------------------------------------------------------------------------------------------------------------
            -- SUBLEQ_FETCH_DATA_B
            -- Get stored data from memory address data_b
            -- Capture data a
            subleq_addr <= ir_b;
            data_a      <= mem_data;
            subleq_sm   <= SUBLEQ_SUBTRACT;

          when SUBLEQ_SUBTRACT =>
            ------------------------------------------------------------------------------------------------------------
            -- SUBLEQ_SUBTRACT
            -- Capture data b
            data_b    <= mem_data;
            subleq_sm <= SUBLEQ_WRITEBACK;

          when SUBLEQ_WRITEBACK =>
            ------------------------------------------------------------------------------------------------------------
            -- SUBLEQ_WRITEBACK
            -- Point memory back to address B
            -- Send ALU to memory
            subleq_we   <= '1';
            subleq_addr <= ir_b;
            subleq_data <= std_logic_vector(signed(data_b) - signed(data_a));
            subleq_sm   <= SUBLEQ_BRANCH_CHECK;

          when SUBLEQ_BRANCH_CHECK =>
            ------------------------------------------------------------------------------------------------------------
            -- SUBLEQ_BRANCH_CHECK
            -- SUBLEQ is met update to pc to target data_c and address C
            -- SUBLEQ not met go to next instruction
            if (signed(subleq_data) <= 0) then
              pc          <= ir_c;
              subleq_addr <= ir_c;
            else
              pc          <= std_logic_vector(unsigned(pc) + 3);
              subleq_addr <= std_logic_vector(unsigned(pc) + 3);
            end if;
            subleq_sm <= SUBLEQ_FETCH_B;

          when others =>
            ------------------------------------------------------------------------------------------------------------
            -- Default state
            subleq_sm <= SUBLEQ_RESET;

        end case;

      end if;

    end if;

  end process;
