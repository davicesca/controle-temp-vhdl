library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControleTemp is
	port(
		clk, reset, desativar, tipo : in std_logic; 
		temp_in, temp_ac : in std_logic_vector(5 downto 0); -- Temperatura de entrada e acionamento
		acionamento : out std_logic_vector(1 downto 0);
		sol_dp_bug : out std_logic;
		segmentos : out std_logic_vector(6 downto 0);
		display : out std_logic_vector(3 downto 0)
	);
end ControleTemp;

architecture Funcionamento of ControleTemp is
	signal digitos : std_logic_vector(15 downto 0); -- Todos os dígitos que serão exibidos no display
	signal contador : integer range 0 to 3 := 0; -- Contador/seletor do display multiplexado
	signal div_clk : std_logic := '0'; -- Divisor de clock - Originalmente, 10MHz
	signal cont_div_clk : integer := 0; -- Limitador do divisor de clock
	signal digito_atual : std_logic_vector(3 downto 0);

	-- Decodificador Binário-BCD
	function BINtoBCD(bin : std_logic_vector(5 downto 0)) return std_logic_vector is
        variable decimal : integer;
        variable dezenas : integer;
        variable unidades : integer;
        variable bcd : std_logic_vector(7 downto 0);
    begin
        decimal := to_integer(unsigned(bin));
        unidades := decimal mod 10;        
        dezenas := decimal / 10;
		  
        bcd(3 downto 0) := std_logic_vector(to_unsigned(unidades, 4));
        bcd(7 downto 4) := std_logic_vector(to_unsigned(dezenas, 4));  
        return bcd;
    end function;
	
	-- Decodificador BCD-Display7Segmentos
	function BCDtoSEG(bcd : std_logic_vector(3 downto 0)) return std_logic_vector is 
		variable seg : std_logic_vector(6 downto 0);
	begin
		case bcd is
			when "0000" => seg := "1111110"; -- 0
			when "0001" => seg := "0110000"; -- 1
			when "0010" => seg := "1101101"; -- 2
			when "0011" => seg := "1111001"; -- 3
			when "0100" => seg := "0110011"; -- 4
			when "0101" => seg := "1011011"; -- 5
			when "0110" => seg := "1011111"; -- 6
			when "0111" => seg := "1110000"; -- 7
			when "1000" => seg := "1111111"; -- 8
			when "1001" => seg := "1111011"; -- 9
			when others => seg := "0000000"; -- Erro!
		end case;	
		return seg;
	end function;
	
begin

	sol_dp_bug <= '0'; -- Solucionando o bug do ponto em cada display :) 

	digitos <= BINtoBCD(temp_in) & BINtoBCD(temp_ac);
	
	-- Lógica para o acionamento do alarme
	process(temp_in, temp_ac)  
	begin

		-- 1 - A temperatura precisa estar abaixo do acionamento 
		-- 0 - A temperatura precisa estar acima do acionamento
		if  (((tipo = '1' and temp_in >= temp_ac) or (tipo = '0' and temp_in <= temp_ac)) and desativar = '0') then
			acionamento <= "11";
		else
			acionamento <= "00";
		end if;
	end process;
	
	-- Funcionamento do Flip-Flop
	process(clk, reset)
	begin
		if reset = '1' then
			div_clk <= '0';
			cont_div_clk <= 0;
		elsif rising_edge(clk) then
			-- Limitando a frequência do clock
			if cont_div_clk = 9999 then
				div_clk <= not div_clk;
				cont_div_clk <= 0;
			else
				cont_div_clk <= cont_div_clk + 1;
			end if;
		end if;
	end process;

	-- Funcionamento do contador responsável pela alteração dos dígitos e displays
	process(div_clk, reset) 
	begin
		if reset = '1' then
			contador <= 0;
		elsif rising_edge(div_clk) then
			contador <= (contador + 1) mod 4;
		end if;
	end process;
	
	process(contador, digitos)
	begin
		case contador is
			when 0 => digito_atual <= digitos(15 downto 12);
			when 1 => digito_atual <= digitos(11 downto 8);
			when 2 => digito_atual <= digitos(7 downto 4);
			when 3 => digito_atual <= digitos(3 downto 0);
		end case;
	end process;
	
	-- Aplicada alteração dos displays
	display <= 
		"0000" when reset = '1' else 
		"0001" when contador = 0 else 
		"0010" when contador = 1 else
		"0100" when contador = 2 else
		"1000" when contador = 3 else
		"0000";
	
	segmentos <= BCDtoSEG(digito_atual); -- Aplicando os segmentos do dígito atual  
		
end Funcionamento;