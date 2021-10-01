<?php

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiProperty;
use ApiPlatform\Core\Annotation\ApiResource;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Doctrine\UuidGenerator;
use Ramsey\Uuid\UuidInterface;
use Symfony\Component\Serializer\Annotation\Groups;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity]
#[ApiResource(
    denormalizationContext: ['groups' => ['category:write']],
    normalizationContext: ['groups' => ['category:read']],
)]
class Category
{

    // #[ORM\Id, ORM\GeneratedValue(strategy: 'CUSTOM'), ORM\CustomIdGenerator(class: UuidGenerator::class)]
    // #[ORM\Column(type: 'uuid', unique: true)]
    // private ?UuidInterface $id = null;

    #[ORM\Id]
    #[ORM\Column(type: 'string', length: 255, unique: true)]
    #[Assert\NotBlank]
    #[ApiProperty(identifier: true)]
    #[Groups(groups: ['category:read', 'category:write', 'item:read', 'list:read'])]
    private String $name;

    #[ORM\Column(type: 'string', length: 255, nullable: true)]
    #[Groups(groups: ['category:read', 'category:write', 'item:read', 'list:read'])]
    private ?String $description;

    // public function getId(): ?UuidInterface
    // {
    //     return $this->id;
    // }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): self
    {
        $this->name = $name;

        return $this;
    }

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(?string $description): self
    {
        $this->description = $description;

        return $this;
    }
}
