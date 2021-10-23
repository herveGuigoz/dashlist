<?php

declare(strict_types=1);

namespace App\Handler;

use ApiPlatform\Core\Exception\InvalidResourceException;
use App\Entity\ListItem;
use App\Service\MercureService;
use Symfony\Component\Messenger\Handler\MessageHandlerInterface;

final class ListItemHandler implements MessageHandlerInterface
{
    public function __construct(private MercureService $mercureService)
    {
    }

    public function __invoke(ListItem $item): void
    {
        $shoppingList = $item->getShoppingList();
        
        if(null == $shoppingList) {
            throw new InvalidResourceException();
        }

        $this->mercureService->publish($shoppingList);
    }
}
