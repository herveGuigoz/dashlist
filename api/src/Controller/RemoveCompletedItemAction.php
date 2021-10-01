<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpKernel\Attribute\AsController;
use App\Entity\ShoppingList;
use App\Service\MercureService;
use Doctrine\ORM\EntityManagerInterface;

/**
 * Clear completed items and publish update to Mercure.
 */
#[AsController]
class RemoveCompletedItemAction extends AbstractController
{
    public function __construct(
        private EntityManagerInterface $entityManager,
        private MercureService $mercureService
    ) {
    }

    public function __invoke(ShoppingList $data): ShoppingList
    {
        $data->removeCompletedItem();

        $this->entityManager->persist($data);
        $this->entityManager->flush();
        
        $this->mercureService->publish($data);
        
        return $data;
    }
}
