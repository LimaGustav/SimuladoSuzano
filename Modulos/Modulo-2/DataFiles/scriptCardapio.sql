USE [master]
GO
/****** Object:  Database [dbCardapio]    Script Date: 16/11/2024 09:48:22 ******/
CREATE DATABASE [dbCardapio]
GO
CREATE TABLE [dbo].[Cardapios](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RestauranteID] [int] NULL,
	[PratoID] [int] NULL,
	[Valor] [float] NULL,
 CONSTRAINT [PK_Cardapios] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categorias]    Script Date: 16/11/2024 09:48:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categorias](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NULL,
 CONSTRAINT [PK_Categorias] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cidades]    Script Date: 16/11/2024 09:48:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cidades](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NULL,
 CONSTRAINT [PK_Cidades] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClienteCurtidas]    Script Date: 16/11/2024 09:48:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClienteCurtidas](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[idCliente] [int] NULL,
	[idPrato] [int] NULL,
 CONSTRAINT [PK_ClienteCurtidas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Perfis]    Script Date: 16/11/2024 09:48:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Perfis](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NULL,
 CONSTRAINT [PK_TiposUsuario] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pratos]    Script Date: 16/11/2024 09:48:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pratos](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NULL,
	[Descricao] [text] NULL,
	[Foto] [varbinary](max) NULL,
	[Ingredientes] [text] NULL,
	[TempoPreparo] [float] NULL,
	[CategoriaID] [int] NULL,
 CONSTRAINT [PK_Pratos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Restaurantes]    Script Date: 16/11/2024 09:48:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restaurantes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NULL,
	[Descricao] [text] NULL,
	[Foto] [varchar](50) NULL,
	[Endereco] [varchar](150) NULL,
	[CidadeID] [int] NULL,
	[TipoID] [int] NULL,
	[DonoID] [int] NULL,
	[DeletedAt] [datetime] NULL,
 CONSTRAINT [PK_Restaurantes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposRestaurate]    Script Date: 16/11/2024 09:48:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposRestaurate](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NULL,
	[Icone] [varchar](150) NULL,
 CONSTRAINT [PK_TiposRestaurate] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 16/11/2024 09:48:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NULL,
	[CPF] [varchar](50) NULL,
	[Email] [varchar](255) NULL,
	[Senha] [varchar](80) NULL,
	[PerfilID] [int] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Cardapios] ON 
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (1, 3, 1, 100)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (2, 5, 3, 50)
GO
SET IDENTITY_INSERT [dbo].[Cardapios] OFF
GO
SET IDENTITY_INSERT [dbo].[Categorias] ON 
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (1, N'Entradas')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (2, N'Sopas')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (3, N'Saladas')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (4, N'Massas')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (5, N'Frutos do mar')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (6, N'Carnes')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (7, N'Queijos')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (8, N'Pratos principais')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (9, N'Especialidades')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (10, N'Bebidas')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (11, N'Drinks')
GO
INSERT [dbo].[Categorias] ([ID], [Nome]) VALUES (12, N'Sobremesas')
GO
SET IDENTITY_INSERT [dbo].[Categorias] OFF
GO
SET IDENTITY_INSERT [dbo].[Cidades] ON 
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (1, N'Aracaju ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (2, N'Belém ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (3, N'Belo Horizonte ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (4, N'Campo Grande ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (5, N'Cuiabá ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (6, N'Curitiba ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (7, N'Florianópolis ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (8, N'Fortaleza ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (9, N'Goiânia ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (10, N'João Pessoa ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (11, N'Macapá ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (12, N'Maceió ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (13, N'Manaus ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (14, N'Natal ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (15, N'Porto Alegre ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (16, N'Porto Velho ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (17, N'Recife ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (18, N'Rio Branco ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (19, N'Rio de Janeiro ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (20, N'Salvador ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (21, N'São Luís ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (22, N'São Paulo ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (23, N'Teresina ')
GO
INSERT [dbo].[Cidades] ([ID], [Nome]) VALUES (24, N'Vitória ')
GO
SET IDENTITY_INSERT [dbo].[Cidades] OFF
GO
SET IDENTITY_INSERT [dbo].[Perfis] ON 
GO
INSERT [dbo].[Perfis] ([ID], [Nome]) VALUES (1, N'Proprietario')
GO
INSERT [dbo].[Perfis] ([ID], [Nome]) VALUES (2, N'Funcionario')
GO
INSERT [dbo].[Perfis] ([ID], [Nome]) VALUES (3, N'Cliente')
GO
SET IDENTITY_INSERT [dbo].[Perfis] OFF
GO
SET IDENTITY_INSERT [dbo].[Pratos] ON 
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (1, N'Espaguetti', N'Massa italiana', NULL, N'Macarrão e molho', 30, 1)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (2, N'Camarão na brasaaaaaa', N'Camarões médios assados na brasa', NULL, N'Camarão', 20, 1)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (3, N'Ragu', N'Especialidade Italiana', NULL, N'Macarrão, vinho e linguiça', 160, 1)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (4, N'Teste', N'teste', NULL, N'tes', 1, 1)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (5, N'Lagosta ', N'Comida tipica', NULL, N'Lagosta e temperos', 12, 5)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (6, N'Pudim de leite ninho', N'Pudim assado de leite ninho sem glutenm', NULL, N'Açucar, leite em po, leite condensado', 65, 12)
GO
SET IDENTITY_INSERT [dbo].[Pratos] OFF
GO
SET IDENTITY_INSERT [dbo].[Restaurantes] ON 
GO
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (1, N'Liliana', N'As melhores massas italianas ', N'Liliana.jpeg', N'Rua Ibiraci', 22, 9, 1, NULL)
GO
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (3, N'Graminha', N'Pizza quadrada cortada na mesa', N'Graminha.jpeg', N'Canal 4', 14, 9, 1, NULL)
GO
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (4, N'Gril', N'Sal com Sal', N'Gril.jpeg', N'Avenida Goias', 22, 3, 1, CAST(N'2024-06-12T15:49:27.163' AS DateTime))
GO
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (5, N'Palácio da Pizza', N'A pizza real', N'Palacio.jpeg', NULL, 19, 9, 4, NULL)
GO
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (6, N'Bonança Burguer', N'Hambúrguer Suculento', N'BonancaBurguer.jpeg', NULL, 5, 10, 4, NULL)
GO
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (7, N'Sushi Central', N'Peixe fresco', N'Suchi.jpeg', N'Rua japa', 7, 11, 4, NULL)
GO
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (8, N'Burger Bonanza', N'Hambúrguer Suculento', N'BurgerBonanza.jpeg', N'Rua Joao Pessoa', 1, 10, 1, NULL)
GO
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (9, N'Cidade do Taco', N'Mexicano de verdade', N'Taco.jpeg', N'Rua Ipiranga', 22, 4, 1, NULL)
GO
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (10, N'Restaurante Seu Zé', N'Os melhores petiscos da cidade', NULL, N'Av Brasil', 22, 3, 1, NULL)
GO
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (11, N'Bolos da Maria', N'Esperimente os melhores bolos', NULL, NULL, 22, 1, 4, NULL)
GO
SET IDENTITY_INSERT [dbo].[Restaurantes] OFF
GO
SET IDENTITY_INSERT [dbo].[TiposRestaurate] ON 
GO
INSERT [dbo].[TiposRestaurate] ([ID], [Nome], [Icone]) VALUES (1, N'Cafeteria', N'coffee.png')
GO
INSERT [dbo].[TiposRestaurate] ([ID], [Nome], [Icone]) VALUES (2, N'Vegano', N'vegan.png')
GO
INSERT [dbo].[TiposRestaurate] ([ID], [Nome], [Icone]) VALUES (3, N'Churrascaria', N'grilling.png')
GO
INSERT [dbo].[TiposRestaurate] ([ID], [Nome], [Icone]) VALUES (4, N'Comida por quilo', N'dish.png')
GO
INSERT [dbo].[TiposRestaurate] ([ID], [Nome], [Icone]) VALUES (8, N'Padaria', N'breed.png')
GO
INSERT [dbo].[TiposRestaurate] ([ID], [Nome], [Icone]) VALUES (9, N'Pizzaria', N'pizza.png')
GO
INSERT [dbo].[TiposRestaurate] ([ID], [Nome], [Icone]) VALUES (10, N'Hamburgueria', N'hamburger.png')
GO
INSERT [dbo].[TiposRestaurate] ([ID], [Nome], [Icone]) VALUES (11, N'Japonesa', N'nigiri.png')
GO
SET IDENTITY_INSERT [dbo].[TiposRestaurate] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuario] ON 
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (1, N'Gustavo Guimaraes', N'43017102807', N'guima@email.com', N'guima', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (2, N'Pedro Lucas', N'43011111807', N'pedro@hotmail.com', N'pedro', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (3, N'Paulo Costa', N'22227102807', N'paulo@email.com', N'paulo123', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (4, N'Maria Penha', N'12341111807', N'penha@email.com', N'penha5', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (5, N'Manoel Roberto', N'55511111807', N'manu@email.com', N'manu1', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (6, N'Benedito Jose', N'12341111333', N'benedito@email.com', N'bene4', 3)
GO
SET IDENTITY_INSERT [dbo].[Usuario] OFF
GO
ALTER TABLE [dbo].[Cardapios]  WITH CHECK ADD  CONSTRAINT [FK_Cardapios_Pratos] FOREIGN KEY([PratoID])
REFERENCES [dbo].[Pratos] ([ID])
GO
ALTER TABLE [dbo].[Cardapios] CHECK CONSTRAINT [FK_Cardapios_Pratos]
GO
ALTER TABLE [dbo].[ClienteCurtidas]  WITH CHECK ADD  CONSTRAINT [FK_ClienteCurtidas_Pratos] FOREIGN KEY([idPrato])
REFERENCES [dbo].[Pratos] ([ID])
GO
ALTER TABLE [dbo].[ClienteCurtidas] CHECK CONSTRAINT [FK_ClienteCurtidas_Pratos]
GO
ALTER TABLE [dbo].[ClienteCurtidas]  WITH CHECK ADD  CONSTRAINT [FK_ClienteCurtidas_Usuario] FOREIGN KEY([idCliente])
REFERENCES [dbo].[Usuario] ([ID])
GO
ALTER TABLE [dbo].[ClienteCurtidas] CHECK CONSTRAINT [FK_ClienteCurtidas_Usuario]
GO
ALTER TABLE [dbo].[Pratos]  WITH CHECK ADD  CONSTRAINT [FK_Pratos_Categorias] FOREIGN KEY([CategoriaID])
REFERENCES [dbo].[Categorias] ([ID])
GO
ALTER TABLE [dbo].[Pratos] CHECK CONSTRAINT [FK_Pratos_Categorias]
GO
ALTER TABLE [dbo].[Restaurantes]  WITH CHECK ADD  CONSTRAINT [FK_Restaurantes_Cidades] FOREIGN KEY([CidadeID])
REFERENCES [dbo].[Cidades] ([ID])
GO
ALTER TABLE [dbo].[Restaurantes] CHECK CONSTRAINT [FK_Restaurantes_Cidades]
GO
ALTER TABLE [dbo].[Restaurantes]  WITH CHECK ADD  CONSTRAINT [FK_Restaurantes_TiposRestaurate] FOREIGN KEY([TipoID])
REFERENCES [dbo].[TiposRestaurate] ([ID])
GO
ALTER TABLE [dbo].[Restaurantes] CHECK CONSTRAINT [FK_Restaurantes_TiposRestaurate]
GO
ALTER TABLE [dbo].[Restaurantes]  WITH CHECK ADD  CONSTRAINT [FK_Restaurantes_Users] FOREIGN KEY([DonoID])
REFERENCES [dbo].[Usuario] ([ID])
GO
ALTER TABLE [dbo].[Restaurantes] CHECK CONSTRAINT [FK_Restaurantes_Users]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Users_TiposUsuario] FOREIGN KEY([PerfilID])
REFERENCES [dbo].[Perfis] ([ID])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Users_TiposUsuario]
GO
USE [master]
GO
ALTER DATABASE [dbCardapio] SET  READ_WRITE 
GO
