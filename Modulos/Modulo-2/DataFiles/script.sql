CREATE DATABASE [dbCardapio]
GO
USE [dbCardapio]
GO
/****** Object:  Table [dbo].[Cardapios]    Script Date: 19/11/2024 13:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Categorias]    Script Date: 19/11/2024 13:24:25 ******/
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
/****** Object:  Table [dbo].[Cidades]    Script Date: 19/11/2024 13:24:25 ******/
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
/****** Object:  Table [dbo].[ClienteCurtidas]    Script Date: 19/11/2024 13:24:25 ******/
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
/****** Object:  Table [dbo].[Perfis]    Script Date: 19/11/2024 13:24:25 ******/
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
/****** Object:  Table [dbo].[Pratos]    Script Date: 19/11/2024 13:24:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pratos](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NULL,
	[Descricao] [text] NULL,
	[Foto] [varchar](max) NULL,
	[Ingredientes] [text] NULL,
	[TempoPreparo] [float] NULL,
	[CategoriaID] [int] NULL,
 CONSTRAINT [PK_Pratos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Restaurantes]    Script Date: 19/11/2024 13:24:25 ******/
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
/****** Object:  Table [dbo].[TiposRestaurate]    Script Date: 19/11/2024 13:24:25 ******/
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
/****** Object:  Table [dbo].[Usuario]    Script Date: 19/11/2024 13:24:25 ******/
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
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (21, 1, 27, 15)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (22, 1, 28, 20)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (23, 1, 29, 18.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (24, 1, 30, 22)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (25, 1, 31, 17)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (26, 1, 32, 19)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (27, 1, 33, 25)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (28, 1, 34, 21)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (29, 3, 27, 17)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (30, 3, 28, 21.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (31, 3, 29, 19)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (32, 3, 30, 22.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (33, 3, 31, 18)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (34, 3, 32, 20)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (35, 3, 33, 26)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (36, 4, 27, 16)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (37, 4, 28, 19.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (38, 4, 29, 18)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (39, 4, 30, 21)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (40, 5, 27, 18)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (41, 5, 28, 22)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (42, 5, 29, 19.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (43, 5, 30, 23)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (44, 5, 31, 18.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (45, 6, 27, 20)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (46, 6, 28, 23.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (47, 6, 29, 20)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (48, 6, 30, 24)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (49, 7, 27, 18)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (50, 7, 28, 19)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (51, 7, 29, 22)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (52, 7, 30, 21)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (53, 7, 31, 23)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (54, 7, 32, 17.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (55, 8, 27, 17.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (56, 8, 28, 18.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (57, 8, 29, 19)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (58, 8, 30, 20)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (59, 9, 27, 22)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (60, 9, 28, 21.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (61, 9, 29, 23)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (62, 10, 27, 19)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (63, 10, 28, 18)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (64, 10, 29, 20)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (65, 10, 30, 21)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (66, 11, 27, 18.5)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (67, 11, 28, 19)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (68, 11, 29, 21)
GO
INSERT [dbo].[Cardapios] ([ID], [RestauranteID], [PratoID], [Valor]) VALUES (69, 11, 30, 22)
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
SET IDENTITY_INSERT [dbo].[ClienteCurtidas] ON 
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (9, 2, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (12, 49, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (13, 53, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (14, 7, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (15, 5, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (16, 15, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (17, 32, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (18, 33, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (20, 16, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (22, 55, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (28, 37, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (30, 20, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (32, 31, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (34, 32, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (35, 18, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (37, 19, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (39, 43, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (40, 36, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (46, 14, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (47, 51, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (48, 31, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (53, 21, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (54, 41, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (56, 37, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (57, 56, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (58, 31, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (62, 30, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (65, 10, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (69, 44, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (70, 41, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (72, 26, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (73, 55, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (76, 4, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (77, 36, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (78, 37, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (79, 43, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (82, 5, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (83, 9, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (85, 12, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (87, 47, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (88, 19, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (92, 35, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (94, 47, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (95, 17, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (96, 30, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (98, 8, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (102, 36, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (105, 53, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (106, 24, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (107, 47, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (108, 21, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (109, 34, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (111, 29, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (113, 39, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (114, 6, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (115, 35, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (116, 11, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (117, 17, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (119, 9, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (120, 37, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (121, 32, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (122, 5, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (128, 38, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (129, 25, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (130, 52, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (131, 38, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (135, 3, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (136, 49, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (137, 33, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (141, 12, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (142, 22, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (143, 51, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (146, 54, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (147, 10, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (148, 23, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (149, 50, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (153, 53, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (154, 1, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (155, 49, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (157, 8, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (158, 32, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (161, 39, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (162, 17, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (164, 57, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (167, 55, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (170, 26, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (172, 14, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (175, 45, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (179, 41, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (182, 13, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (183, 6, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (184, 52, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (188, 26, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (193, 28, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (195, 34, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (199, 23, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (200, 21, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (201, 9, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (203, 2, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (205, 40, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (209, 55, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (211, 51, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (212, 7, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (213, 40, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (216, 5, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (218, 13, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (221, 24, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (223, 21, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (224, 22, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (229, 51, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (236, 7, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (238, 37, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (239, 54, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (240, 50, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (241, 23, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (244, 51, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (245, 23, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (251, 30, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (255, 48, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (256, 26, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (257, 41, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (258, 47, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (260, 19, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (263, 37, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (264, 52, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (265, 23, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (266, 29, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (267, 28, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (268, 34, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (270, 40, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (271, 23, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (272, 13, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (273, 52, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (276, 27, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (277, 45, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (280, 47, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (281, 30, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (282, 52, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (285, 5, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (286, 13, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (288, 1, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (291, 46, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (292, 49, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (293, 42, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (295, 51, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (298, 53, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (300, 42, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (304, 44, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (306, 52, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (308, 31, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (310, 22, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (313, 13, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (314, 54, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (315, 44, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (316, 15, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (318, 4, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (319, 8, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (321, 42, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (322, 14, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (323, 12, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (324, 26, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (325, 10, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (326, 2, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (328, 7, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (329, 10, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (330, 3, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (331, 38, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (332, 11, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (333, 52, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (337, 13, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (338, 8, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (340, 27, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (343, 47, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (344, 20, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (345, 32, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (346, 23, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (347, 47, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (350, 26, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (352, 47, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (353, 3, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (355, 13, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (357, 48, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (359, 22, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (360, 2, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (361, 21, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (369, 30, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (372, 7, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (373, 8, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (375, 11, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (376, 46, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (377, 31, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (378, 38, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (379, 19, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (380, 4, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (386, 49, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (389, 7, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (392, 46, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (393, 40, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (395, 12, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (397, 40, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (400, 54, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (402, 38, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (404, 22, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (406, 53, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (408, 50, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (410, 39, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (412, 26, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (419, 9, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (420, 18, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (422, 7, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (423, 14, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (425, 28, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (427, 25, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (430, 47, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (431, 44, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (436, 9, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (437, 46, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (438, 54, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (439, 38, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (440, 33, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (441, 39, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (442, 20, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (443, 34, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (446, 31, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (447, 52, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (449, 28, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (450, 32, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (453, 23, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (454, 38, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (455, 49, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (456, 11, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (457, 20, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (458, 13, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (463, 56, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (464, 44, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (465, 5, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (466, 13, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (467, 27, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (469, 33, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (472, 1, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (474, 27, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (475, 25, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (481, 1, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (483, 11, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (484, 18, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (492, 29, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (493, 4, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (498, 34, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (500, 52, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (501, 2, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (502, 9, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (503, 25, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (506, 17, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (513, 54, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (514, 44, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (515, 8, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (517, 38, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (518, 53, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (519, 49, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (520, 47, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (521, 1, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (522, 12, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (523, 26, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (524, 21, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (525, 39, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (526, 35, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (527, 52, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (529, 41, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (530, 6, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (533, 54, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (539, 32, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (540, 55, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (542, 44, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (543, 14, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (546, 18, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (547, 49, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (549, 33, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (550, 26, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (551, 45, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (552, 18, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (554, 45, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (555, 37, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (560, 21, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (562, 50, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (563, 25, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (565, 8, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (566, 31, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (569, 25, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (570, 17, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (572, 39, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (573, 30, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (574, 41, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (575, 27, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (578, 20, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (579, 54, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (580, 24, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (581, 54, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (582, 57, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (583, 41, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (586, 18, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (590, 20, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (591, 43, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (595, 36, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (597, 45, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (598, 50, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (600, 17, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (602, 37, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (603, 9, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (604, 57, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (605, 15, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (608, 35, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (609, 40, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (611, 3, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (615, 11, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (616, 45, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (617, 56, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (621, 16, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (624, 56, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (625, 16, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (626, 13, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (629, 45, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (633, 47, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (634, 6, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (636, 26, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (637, 16, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (638, 4, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (639, 31, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (640, 1, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (641, 35, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (643, 2, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (644, 23, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (645, 25, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (650, 17, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (651, 35, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (652, 14, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (654, 31, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (656, 51, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (662, 56, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (663, 5, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (665, 26, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (666, 36, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (668, 44, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (669, 35, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (671, 47, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (672, 43, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (676, 44, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (678, 17, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (679, 13, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (683, 57, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (685, 23, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (687, 49, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (688, 43, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (689, 21, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (691, 4, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (692, 33, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (694, 24, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (695, 49, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (697, 12, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (699, 42, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (705, 46, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (707, 4, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (708, 29, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (709, 14, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (710, 42, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (711, 15, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (712, 56, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (715, 32, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (717, 10, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (720, 15, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (726, 14, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (727, 32, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (730, 26, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (733, 54, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (734, 16, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (736, 14, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (737, 29, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (738, 45, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (741, 13, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (745, 15, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (750, 14, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (752, 29, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (753, 9, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (755, 33, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (756, 31, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (757, 32, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (759, 3, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (761, 30, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (763, 21, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (764, 54, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (765, 7, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (767, 32, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (768, 47, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (769, 6, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (770, 21, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (774, 26, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (775, 14, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (779, 17, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (785, 18, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (786, 26, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (787, 46, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (789, 37, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (790, 18, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (791, 53, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (792, 23, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (793, 56, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (794, 37, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (795, 36, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (796, 25, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (798, 39, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (799, 31, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (801, 9, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (803, 34, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (805, 12, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (807, 46, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (809, 24, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (814, 9, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (815, 3, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (818, 51, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (819, 30, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (820, 56, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (824, 1, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (825, 41, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (826, 25, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (827, 20, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (828, 2, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (830, 35, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (834, 49, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (835, 54, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (836, 40, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (837, 13, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (840, 37, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (843, 6, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (847, 57, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (848, 50, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (850, 51, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (851, 9, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (858, 41, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (859, 55, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (860, 13, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (862, 49, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (868, 29, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (871, 12, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (873, 4, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (875, 46, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (876, 41, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (878, 15, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (879, 32, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (880, 36, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (881, 21, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (882, 46, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (887, 21, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (888, 29, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (890, 4, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (894, 25, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (895, 31, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (896, 22, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (897, 31, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (899, 33, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (901, 14, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (904, 23, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (905, 16, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (908, 20, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (910, 14, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (911, 27, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (914, 42, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (915, 13, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (918, 27, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (919, 18, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (920, 23, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (921, 25, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (925, 9, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (926, 33, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (929, 43, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (930, 13, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (932, 18, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (933, 19, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (935, 15, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (936, 1, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (938, 49, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (940, 38, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (942, 49, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (943, 13, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (944, 34, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (945, 21, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (949, 8, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (950, 28, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (951, 20, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (953, 37, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (954, 22, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (955, 5, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (956, 1, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (957, 26, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (958, 35, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (959, 48, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (961, 37, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (962, 3, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (964, 45, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (965, 11, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (967, 54, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (970, 32, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (972, 2, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (973, 24, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (976, 25, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (977, 51, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (978, 25, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (979, 42, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (981, 9, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (983, 10, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (984, 42, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (985, 9, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (986, 1, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (987, 33, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (990, 39, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (991, 8, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (992, 24, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (993, 46, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (994, 40, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (995, 1, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (999, 5, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1000, 19, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1007, 22, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1008, 7, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1009, 56, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1010, 53, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1013, 53, 34)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1014, 17, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1015, 15, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1018, 42, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1019, 13, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1020, 13, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1024, 35, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1028, 2, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1030, 24, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1032, 23, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1033, 48, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1034, 36, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1037, 16, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1038, 9, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1040, 8, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1046, 56, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1047, 7, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1049, 35, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1050, 11, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1052, 51, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1054, 5, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1055, 6, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1057, 8, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1058, 46, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1060, 45, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1061, 30, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1062, 19, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1064, 55, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1066, 18, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1067, 47, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1068, 4, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1072, 50, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1075, 45, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1078, 46, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1080, 9, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1082, 26, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1085, 38, 40)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1086, 23, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1087, 47, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1088, 18, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1092, 22, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1093, 52, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1095, 57, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1096, 27, 27)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1100, 25, 37)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1101, 38, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1103, 15, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1104, 56, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1106, 46, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1108, 45, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1109, 5, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1110, 44, 1)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1111, 55, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1112, 40, 42)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1114, 23, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1117, 41, 5)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1120, 38, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1121, 23, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1125, 3, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1130, 43, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1132, 14, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1136, 6, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1144, 16, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1145, 27, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1146, 51, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1148, 35, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1149, 19, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1151, 8, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1153, 17, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1156, 3, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1158, 50, 31)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1160, 27, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1162, 17, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1163, 33, 43)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1167, 27, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1168, 32, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1169, 48, 39)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1171, 33, 44)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1173, 5, 32)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1174, 25, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1175, 15, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1176, 18, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1178, 9, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1181, 9, 45)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1182, 53, 2)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1183, 5, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1185, 28, 36)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1186, 22, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1189, 6, 33)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1191, 27, 46)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1193, 44, 41)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1194, 29, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1195, 33, 35)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1198, 20, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1199, 20, 29)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1200, 25, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1201, 12, 28)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1203, 22, 3)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1204, 7, 30)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1205, 46, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1208, 14, 38)
GO
INSERT [dbo].[ClienteCurtidas] ([ID], [idCliente], [idPrato]) VALUES (1209, 47, 33)
GO
SET IDENTITY_INSERT [dbo].[ClienteCurtidas] OFF
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
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (1, N'Espaguetti', N'Massa italiana', N'1.jpg', N'Macarrão e molho', 30, 1)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (2, N'Camarão na brasaaaaaa', N'Camarões médios assados na brasa', N'2.jpg', N'Camarão', 20, 1)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (3, N'Ragu', N'Especialidade Italiana', N'3.jpg', N'Macarrão, vinho e linguiça', 160, 1)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (5, N'Lagosta ', N'Comida tipica', N'5.jpg', N'Lagosta e temperos', 12, 5)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (27, N'Bruschetta de Tomate', N'Entradas de pão com tomate, alho e manjericão.', N'27.jpg', N'Pão, tomate, alho, manjericão', 15, 1)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (28, N'Sopa de Cebola', N'Sopa clássica de cebola com queijo gratinado.', N'28.jpg', N'Cebola, queijo, caldo de carne, pão', 30, 2)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (29, N'Salada Grega', N'Salada com tomate, pepino, cebola, azeitonas e queijo feta.', N'29.jpg', N'Tomate, pepino, cebola, azeitonas, queijo feta', 10, 3)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (30, N'Lasanha à Bolonhesa', N'Massa em camadas com molho bolonhesa.', N'30.jpg', N'Massa, carne moída, molho de tomate, queijo', 50, 4)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (31, N'Camarão na Moranga', N'Frutos do mar com abóbora e molho cremoso.', N'31.jpg', N'Camarão, abóbora, creme de leite', 60, 5)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (32, N'Bife à Milanesa', N'Carne empanada e frita.', N'32.jpg', N'Carne bovina, farinha de rosca, ovo, óleo', 30, 6)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (33, N'Fondue de Queijo', N'Fondue com queijo derretido.', N'33.jpg', N'Queijo Gruyère, queijo Emmental, vinho branco', 25, 7)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (34, N'Filé Mignon ao Molho Madeira', N'Prato principal com molho madeira.', N'34.jpg', N'Filé mignon, vinho madeira, champignons', 45, 8)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (35, N'Risoto de Pato', N'Especialidade com pato e arroz cremoso.', N'35.jpg', N'Arroz, pato, caldo de legumes', 40, 9)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (36, N'Suco de Laranja Natural', N'Bebida refrescante feita com laranja.', N'36.jpg', N'Laranja', 5, 10)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (37, N'Margarita', N'Drink clássico com tequila, suco de limão e sal.', N'37.jpg', N'Tequila, suco de limão, sal', 10, 11)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (38, N'Torta de Limão', N'Sobremesa com base crocante e creme de limão.', N'38.jpg', N'Limão, leite condensado, bolacha', 20, 12)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (39, N'Sopa de Legumes', N'Sopa nutritiva com diversos legumes.', N'39.jpg', N'Batata, cenoura, abobrinha, caldo de legumes', 35, 2)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (40, N'Salada Caesar', N'Salada com alface, molho Caesar e croutons.', N'40.jpg', N'Alface, molho Caesar, croutons, queijo', 15, 3)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (41, N'Espaguete Carbonara', N'Massa com bacon e molho cremoso de ovos.', N'41.jpg', N'Espaguete, bacon, ovo, queijo parmesão', 20, 4)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (42, N'Peixe Grelhado com Alcaparras', N'Frutos do mar com molho de alcaparras.', N'42.jpg', N'Peixe, alcaparras, limão', 30, 5)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (43, N'Picanha na Grelha', N'Carne bovina grelhada com sal grosso.', N'43.jpg', N'Picanha, sal grosso', 40, 6)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (44, N'Queijo Brie com Geleia', N'Queijo brie servido com geleia de pimenta.', N'44.jpg', N'Queijo Brie, geleia de pimenta', 15, 7)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (45, N'Filé à Parmegiana', N'Prato principal com filé empanado e molho.', N'45.jpg', N'Filé, molho de tomate, queijo', 50, 8)
GO
INSERT [dbo].[Pratos] ([ID], [Nome], [Descricao], [Foto], [Ingredientes], [TempoPreparo], [CategoriaID]) VALUES (46, N'Pastel de Belém', N'Doce português com creme de ovos.', N'46.jpg', N'Massa folhada, creme de ovos', 25, 12)
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
INSERT [dbo].[Restaurantes] ([ID], [Nome], [Descricao], [Foto], [Endereco], [CidadeID], [TipoID], [DonoID], [DeletedAt]) VALUES (9, N'Cidade do Taco', N'Mexicano de verdade', N'Taco.jpeg', N'Rua Ipiranga', 22, 4, 1, CAST(N'2024-11-18T13:31:59.777' AS DateTime))
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
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (7, N'João Silva', N'12345678901', N'joao.silva@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (8, N'Maria Oliveira', N'23456789012', N'maria.oliveira@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (9, N'Carlos Souza', N'34567890123', N'carlos.souza@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (10, N'Ana Costa', N'45678901234', N'ana.costa@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (11, N'Felipe Almeida', N'56789012345', N'felipe.almeida@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (12, N'Juliana Pereira', N'67890123456', N'juliana.pereira@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (13, N'Ricardo Lima', N'78901234567', N'ricardo.lima@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (14, N'Patrícia Santos', N'89012345678', N'patricia.santos@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (15, N'Eduardo Rocha', N'90123456789', N'eduardo.rocha@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (16, N'Beatriz Martins', N'01234567890', N'beatriz.martins@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (17, N'Lucas Ferreira', N'12345678901', N'lucas.ferreira@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (18, N'Camila Costa', N'23456789012', N'camila.costa@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (19, N'Ricardo Souza', N'34567890123', N'ricardo.souza@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (20, N'Amanda Silva', N'45678901234', N'amanda.silva@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (21, N'Rafael Oliveira', N'56789012345', N'rafael.oliveira@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (22, N'Patrícia Alves', N'67890123456', N'patricia.alves@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (23, N'Gustavo Martins', N'78901234567', N'gustavo.martins@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (24, N'Mariana Pereira', N'89012345678', N'mariana.pereira@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (25, N'Lúcia Costa', N'90123456789', N'lucia.costa@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (26, N'Leandro Rocha', N'01234567890', N'leandro.rocha@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (27, N'Gabriela Lima', N'12345678901', N'gabriela.lima@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (28, N'Fernanda Silva', N'23456789012', N'fernanda.silva@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (29, N'Sérgio Souza', N'34567890123', N'sergio.souza@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (30, N'Tatiane Almeida', N'45678901234', N'tatiane.almeida@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (31, N'Thiago Santos', N'56789012345', N'thiago.santos@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (32, N'Cláudia Ferreira', N'67890123456', N'claudia.ferreira@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (33, N'Bruna Oliveira', N'78901234567', N'bruna.oliveira@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (34, N'Marcos Costa', N'89012345678', N'marcos.costa@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (35, N'José Almeida', N'90123456789', N'jose.almeida@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (36, N'Simone Martins', N'01234567890', N'simone.martins@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (37, N'Carlos Lima', N'12345678901', N'carlos.lima@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (38, N'Tatiane Pereira', N'23456789012', N'tatiane.pereira@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (39, N'Renato Silva', N'34567890123', N'renato.silva@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (40, N'Mário Rocha', N'45678901234', N'mario.rocha@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (41, N'Camila Almeida', N'56789012345', N'camila.almeida@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (42, N'Adriana Souza', N'67890123456', N'adriana.souza@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (43, N'Ricardo Costa', N'78901234567', N'ricardo.costa@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (44, N'Felipe Oliveira', N'89012345678', N'felipe.oliveira@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (45, N'Júlia Ferreira', N'90123456789', N'julia.ferreira@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (46, N'Eduardo Pereira', N'01234567890', N'eduardo.pereira@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (47, N'Simone Rocha', N'12345678901', N'simone.rocha@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (48, N'Laura Martins', N'23456789012', N'laura.martins@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (49, N'Pedro Silva', N'34567890123', N'pedro.silva@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (50, N'Vanessa Lima', N'45678901234', N'vanessa.lima@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (51, N'Isabela Souza', N'56789012345', N'isabela.souza@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (52, N'Juliana Rocha', N'67890123456', N'juliana.rocha@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (53, N'Lucas Santos', N'78901234567', N'lucas.santos@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (54, N'Rita Almeida', N'89012345678', N'rita.almeida@email.com', N'senha789', 3)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (55, N'Eduardo Lima', N'90123456789', N'eduardo.lima@email.com', N'senha123', 1)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (56, N'Viviane Ferreira', N'01234567890', N'viviane.ferreira@email.com', N'senha456', 2)
GO
INSERT [dbo].[Usuario] ([ID], [Nome], [CPF], [Email], [Senha], [PerfilID]) VALUES (57, N'Thiago Pereira', N'12345678901', N'thiago.pereira@email.com', N'senha789', 3)
GO
SET IDENTITY_INSERT [dbo].[Usuario] OFF
GO
ALTER TABLE [dbo].[Cardapios]  WITH CHECK ADD  CONSTRAINT [FK_Cardapios_Pratos] FOREIGN KEY([PratoID])
REFERENCES [dbo].[Pratos] ([ID])
GO
ALTER TABLE [dbo].[Cardapios] CHECK CONSTRAINT [FK_Cardapios_Pratos]
GO
ALTER TABLE [dbo].[Cardapios]  WITH CHECK ADD  CONSTRAINT [FK_Cardapios_Restaurantes] FOREIGN KEY([RestauranteID])
REFERENCES [dbo].[Restaurantes] ([ID])
GO
ALTER TABLE [dbo].[Cardapios] CHECK CONSTRAINT [FK_Cardapios_Restaurantes]
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
