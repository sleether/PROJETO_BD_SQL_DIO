-- Criação/Aleração das tabelas do SCHEMA E-COMMERCE

CREATE SCHEMA e_commerce;
SHOW SCHEMAS;
USE E_COMMERCE;

CREATE TABLE login (
	idlogin smallint auto_increment,
    email varchar(45) not null,
    password varchar(20) not null,
    administrator boolean not null, 
    constraint pk_login primary key (idlogin) 
);

ALTER TABLE login modify column idlogin int;
ALTER TABLE login modify column idlogin int auto_increment not null;

CREATE TABLE cliente (
	idcliente int auto_increment not null,
    nome varchar(80) not null,
    cpf_cnpj varchar (15) not null, -- Unico valor por cliente
    rg_ie varchar(15) not null,  -- Unico valor por cliente
    datanasc date not null,
    sexo char not null,
    telefone varchar(15) not null,
    celular varchar(15)not null,
    email varchar(45) not null,
    datacadastro date not null,
    observacoes varchar(300),
    constraint pk_cliente primary key (idcliente)
);

ALTER TABLE cliente 
add idendereco int,
add constraint fk_idendereco foreign key (idendereco) references endereco (idendereco);

ALTER TABLE cliente
add unique (cpf_cnpj),
add unique (rg_ie);

ALTER TABLE cliente
modify column datanasc varchar(11),
modify column datacadastro varchar(11);

CREATE TABLE endereco (
	idendereco int auto_increment not null,
    rua varchar(80) not null,
    numero varchar(6) not null,
    bairro varchar(60) not null,
    cep int(9) not null,
	constraint pk_endereco primary key (idendereco)
);

ALTER TABLE endereco
add idcidade int,
add constraint fk_idcidade foreign key (idcidade) references cidade (idcidade);

CREATE TABLE cidade (
	idcidade int auto_increment not null,
    nome varchar(80) not null,
	constraint pk_cidade primary key (idcidade)
    );
    
ALTER TABLE cidade
add idestado int,
add constraint fk_idestado foreign key (idestado) references estado (idestado);


CREATE TABLE estado (
	idestado int auto_increment not null,
    estado varchar(60) not null,
    uf varchar(2) not null,
    pais varchar(60) not null,
    constraint pk_estado primary key (idestado)
);

CREATE TABLE fornecedor (
	idfornecedor int auto_increment not null,
	idendereco int,
    razao_social varchar(45) not null,
    cnpj varchar(15) not null, -- valor unico para cada fornecedor
	constraint cpnj_fornecedor unique (cnpj),
    constraint fk_end_fornecedor foreign key (idendereco) references endereco (idendereco),
    constraint pk_fornecedor primary key (idfornecedor)
);

ALTER TABLE fornecedor
add contato char(11) not null;

CREATE TABLE vendedor_teceirizado (
	idterceiro int auto_increment not null,
    idendereco int,
    razao_nome varchar(45) not null,
    local varchar(45),
    constraint fk_end_terceiro foreign key (idendereco) references endereco (idendereco),
    constraint pk_terceiro primary key (idterceiro)
);

ALTER TABLE vendedor_terceirizado
add contato char(11) not null;

ALTER TABLE vendedor_teceirizado rename to vendedor_terceirizado;

ALTER TABLE vendedor_terceirizado
add cpf_cnpj varchar(15) not null,
add constraint cpf_cnpj_vendedor_terceirizado unique (cpf_cnpj);

ALTER TABLE vendedor_terceirizado
modify column cpf_cnpj varchar(15),
add cnpj varchar(15),
add PJ boolean;

ALTER TABLE vendedor_terceirizado
drop constraint cpf_cnpj_vendedor_terceirizado,
drop cpf_cnpj;

ALTER TABLE vendedor_terceirizado
add cpf varchar(15),
add constraint cnpj_vendedor_terceirizado unique (cnpj),
add constraint cpf_vendedor_terceirizado unique (cpf);

desc vendedor_terceirizado;

CREATE TABLE endereco_entrega (
	idendereco_entrega int auto_increment not null,
    idcidade int,
    rua varchar(60) not null,
    numero varchar(6) not null,
    bairro varchar(45) not null,
    cep varchar(9) not null,
    constraint fk_cidade_entrega foreign key (idcidade) references cidade (idcidade),
    constraint pk_end_entrega primary key (idendereco_entrega)
);

CREATE TABLE produto (
	idproduto int auto_increment not null,
    descricao varchar(150) not null,
	valorpro float not null,
    constraint pk_produto primary key (idproduto)
);

ALTER TABLE produto
add idmarca int not null,
add idcategoria int not null,
add idtamanho int not null;

alter table produto
modify column valorpro numeric;


CREATE TABLE estoque (
	idproduto int,
    idfornecedor int,
    quantidade int,
    constraint fk_pro_estoque foreign key (idproduto) references produto (idproduto),
    constraint fk_for_estoque foreign key (idfornecedor) references fornecedor (idfornecedor),
    constraint pk_estoque primary key (idproduto, idfornecedor)
);

CREATE TABLE estoque_vendedor (
	idvendedor int,
    idproduto int,
    quantidade int,
    constraint fk_proven_estoque foreign key (idproduto) references produto (idproduto),
    constraint fk_ven_estoque foreign key (idvendedor) references vendedor_terceirizado (idterceiro),
    constraint pk_estoque primary key (idproduto, idvendedor)
);

CREATE TABLE if not exists marca (
	idmarca int auto_increment not null,
    nome varchar(15),
    constraint pk_marca primary key (idmarca)
);

CREATE TABLE tamanho (
	idtamanho int auto_increment not null,
    tamanho varchar(10),
    constraint pk_tamanho primary key (idtamanho)
);

CREATE TABLE categoria (
	idcategoria int auto_increment not null,
    nome varchar(10),
    constraint pk_categoria primary key (idcategoria)
);

CREATE TABLE tipoproduto (
	idmarca int,
    idcategoria int,
    idtamanho int,
    disponivel boolean,
    constraint fk_categoria foreign key (idcategoria) references categoria(idcategoria),
    constraint fk_tamanho foreign key (idtamanho) references tamanho(idtamanho),
    constraint pk_tipoproduto primary key (idmarca, idcategoria, idtamanho)
);
select * from tipoproduto;

ALTER TABLE tipoproduto add constraint fk_marca foreign key (idmarca) references marca (idmarca);

CREATE TABLE pedido (
	idpedido int auto_increment not null,
    idcliente int,
    idend_entrega int,
    idstatuspedido int,
    idtpagamento int,
    descricao varchar(45) not null,
    frete float not null,
    datavenda date not null,
    predataentrega date not null,
    valorcompra float not null,
    constraint fk_cliente_p foreign key (idcliente) references cliente(idcliente),
    constraint fk_endentrega foreign key (idend_entrega) references endereco_entrega(idendereco_entrega),
    constraint pk_pedido primary key (idpedido)    
);

ALTER TABLE pedido
modify column datavenda varchar(10),
modify column predataentrega varchar(10);
ALTER TABLE pedido
add idproduto int,
add constraint fk_produto_pd foreign key (idproduto) references produto(idproduto);

CREATE TABLE statuspedido (
	idstatus int auto_increment not null,
    situacao varchar(15),
    constraint pk_status primary key (idstatus)
    );
    
CREATE TABLE formapagamento (
	idpagamento int auto_increment not null,
    idboleto int,
    idpix int,
    idcartao int,
    constraint pk_pagamento primary key (idpagamento)   
);

ALTER TABLE formapagamento
add constraint fk_frm_cartao foreign key (idcartao) references cartao(idcartao),
add constraint fk_frm_pix foreign key (idpix) references pix(idpix),
add constraint fk_frm_boleto foreign key (idboleto) references boleto(idboleto);

CREATE TABLE cartao (
	idcartao int auto_increment not null,
    tipo varchar(7) not null,
    validade datetime(2) not null,
    emissao datetime(2) not null,
    nome_dono varchar(45) not null,
    numero varchar(16) not null,
    cvv varchar(3) not null,
    constraint nunico unique (numero),
    constraint pk_cartao primary key (idcartao)
);

ALTER TABLE cartao
add parcelado boolean not null,
add qtdparc int not null;

ALTER TABLE cartao
modify column validade varchar(8),
modify column emissao varchar(8);

CREATE TABLE pix (
	idpix int auto_increment not null,
    chave varchar(300) not null,
    constraint unico_pix unique (chave),
    constraint pk_pix primary key (idpix)
);

CREATE TABLE boleto (
	idboleto int auto_increment not null,
    codigobarras int not null,
    constraint pk_boleto primary key (idboleto)
);

CREATE TABLE entrega (
	identrega int auto_increment not null,
    idendentrega int,
    idstatusentrega int,
    transportadora varchar(25) not null,
    codrastreio varchar(45) not null,
    constraint fk_entrega_end foreign key (idendentrega) references endereco_entrega(idendereco_entrega),
    constraint fk_entrega_status foreign key (idstatusentrega) references status_entrega(idstatus),
    constraint pk_entrega primary key (identrega)
);

CREATE TABLE status_entrega (
	idstatus int auto_increment not null,
    situacao varchar(15),
    constraint pk_status_entrega primary key (idstatus)
);