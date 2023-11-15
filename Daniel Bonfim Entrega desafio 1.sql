--1 Valor total das vendas e dos fretes por produto e ordem de venda
		SELECT 
			SUM(D.[Valor]) AS 'VALOR_BRUTO',
			SUM(C.ValorFrete) AS 'VALOR_FRETE',
			P.Produto
		FROM [dados].[dbo].[FatoCabecalho_DadosModelagem] C
		LEFT JOIN  [dados].[dbo].[FatoDetalhes_DadosModelagem] D ON C.CupomID=D.CupomID
		LEFT JOIN [dados].[dbo].[Produtos] P ON D.ProdutoID=P.ProdutoID
		GROUP BY P.Produto
		ORDER BY P.Produto, 'VALOR_BRUTO'

-- 2 Valor de venda por tipo de produto
-- Não tinha "tipo de produto", usei categoria
		SELECT 
			SUM(D.[Valor]) AS 'VALOR_BRUTO',
			CA.Categoria
		from  [dados].[dbo].[FatoDetalhes_DadosModelagem] D 
		LEFT JOIN [dados].[dbo].[Produtos] P ON D.ProdutoID=P.ProdutoID
		LEFT JOIN [dados].[dbo].Categoria CA ON CA.CategoriaID=P.CategoriaID
		GROUP BY CA.Categoria
		ORDER BY CA.Categoria, 'VALOR_BRUTO'

-- 3 Quantidade e valor das vendas por dia, mês, ano
		SELECT 
			DAY(C.[Data]) AS 'DIA',
			MONTH(C.[Data]) AS 'MES',
			YEAR(C.[Data]) AS 'ANO',
			COUNT(C.CupomID) AS 'QTD DE VENDAS',
			SUM(D.[Valor]) AS 'VALOR_BRUTO'
		FROM [dados].[dbo].[FatoCabecalho_DadosModelagem] C
		LEFT JOIN  [dados].[dbo].[FatoDetalhes_DadosModelagem] D ON C.CupomID=D.CupomID
		GROUP BY YEAR(C.[Data]),MONTH(C.[Data]),DAY(C.[Data])
		ORDER BY YEAR(C.[Data]),MONTH(C.[Data]),DAY(C.[Data])

-- 4 Lucro dos meses;
		SELECT 
			MONTH(C.[Data]) AS 'MES',
			SUM(D.[ValorLiquido]) AS 'LUCRO'
		FROM [dados].[dbo].[FatoCabecalho_DadosModelagem] C
		LEFT JOIN  [dados].[dbo].[FatoDetalhes_DadosModelagem] D ON C.CupomID=D.CupomID
		GROUP BY MONTH(C.[Data])
		ORDER BY MONTH(C.[Data])

-- 5 Venda por produto;
		SELECT 
			P.Produto,
			COUNT(C.CupomID) AS 'QTD DE VENDAS'
		FROM [dados].[dbo].[FatoCabecalho_DadosModelagem] C
		LEFT JOIN  [dados].[dbo].[FatoDetalhes_DadosModelagem] D ON C.CupomID=D.CupomID
		LEFT JOIN [dados].[dbo].[Produtos] P ON D.ProdutoID=P.ProdutoID
		GROUP BY P.Produto
		ORDER BY 'QTD DE VENDAS', P.Produto

-- 6 Venda por cliente, cidade do cliente e estado;
-- Não existe a coluna "estado", usei região
		SELECT 
			CL.Cliente,
			CL.Cidade,
			CL.Regiao,
			COUNT(C.CupomID) AS 'QTD DE VENDAS'
		FROM [dados].[dbo].[FatoCabecalho_DadosModelagem] C
		LEFT JOIN [dados].[dbo].[Clientes] CL ON CL.ClienteID=C.ClienteID
		GROUP BY CL.Cliente,CL.Cidade,CL.Regiao
		ORDER BY 'QTD DE VENDAS'

--7 Média de produtos vendidos
		SELECT 
			ROUND(AVG(CAST(D.[Quantidade] AS FLOAT)),2) AS 'Média de Produtos',
			P.Produto
		FROM [dados].[dbo].[FatoDetalhes_DadosModelagem] D
		LEFT JOIN [dados].[dbo].[Produtos] P ON D.ProdutoID=P.ProdutoID
		GROUP BY P.Produto
		ORDER BY 'Média de Produtos'

--8 Média de compras que um cliente faz

		SELECT 	
			ROUND(
				CAST(COUNT(C.CupomID) AS FLOAT)/
				CAST(COUNT(DISTINCT(CL.Cliente)) AS FLOAT)
				,2) AS 'Média de compras por clientes'
		FROM [dados].[dbo].[FatoCabecalho_DadosModelagem] C
		LEFT JOIN [dados].[dbo].[Clientes] CL ON CL.ClienteID=C.ClienteID
		
