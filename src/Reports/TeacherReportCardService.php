<?php

namespace iEducar\Reports;

use iEducar\Reports\Contracts\TeacherReportCard;

class TeacherReportCardService implements TeacherReportCard
{
    /**
     * Retorna as opções de boletim do professor.
     *
     * @return array
     */
    public function getOptions(): array
    {
        // Tenta carregar a classe legacy dinamicamente
        // A classe pode estar em ieducar/lib/Portabilis/Model/Report/TipoBoletim.php
        $legacyPath = base_path('ieducar/lib/Portabilis/Model/Report/TipoBoletim.php');
        
        if (file_exists($legacyPath)) {
            require_once $legacyPath;
        }
        
        // Verifica se a classe existe após tentar carregar
        if (class_exists('Portabilis_Model_Report_TipoBoletim')) {
            try {
                return \Portabilis_Model_Report_TipoBoletim::getInstance()->getEnums();
            } catch (\Exception $e) {
                // Se houver erro ao obter as opções, retorna array vazio
                return [];
            }
        }
        
        // Se a classe não existir, retorna array vazio
        // Isso permite que o formulário funcione mesmo sem a classe legacy
        return [];
    }
}

