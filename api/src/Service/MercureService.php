<?php

declare(strict_types=1);

namespace App\Service;

use ApiPlatform\Core\Api\IriConverterInterface;
use ApiPlatform\Core\Api\UrlGeneratorInterface;
use ApiPlatform\Core\JsonLd\Serializer\ItemNormalizer;
use ApiPlatform\Core\Metadata\Resource\Factory\ResourceMetadataFactoryInterface;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Mercure\Update;
use Symfony\Component\Serializer\SerializerInterface;

/**
 * Send message to Mercure hub
 */
class MercureService
{
    public function __construct(
        private IriConverterInterface $iriConverter,
        private SerializerInterface $serializer,
        private HubInterface $hub,
        private ResourceMetadataFactoryInterface $resourceMetadataFactory,
        private EntityManagerInterface $entityManager,
    ) {
    }

    public function publish($data): void
    {
        $update = new Update(
          $this->iriConverter->getIriFromItem($data, UrlGeneratorInterface::ABS_URL),
          $this->serializer->serialize(
              $data,
              ItemNormalizer::FORMAT,
          )
        );

        $this->hub->publish($update);
    }
}
