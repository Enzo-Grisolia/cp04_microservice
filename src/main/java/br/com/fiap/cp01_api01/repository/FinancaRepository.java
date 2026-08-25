package br.com.fiap.cp01_api01.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import br.com.fiap.cp01_api01.model.Financa;

public interface FinancaRepository extends JpaRepository<Financa, Long> {

}
