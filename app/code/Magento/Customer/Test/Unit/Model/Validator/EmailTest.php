<?php
/**
 * Copyright 2026 Adobe
 * All Rights Reserved.
 */
declare(strict_types=1);

namespace Magento\Customer\Test\Unit\Model\Validator;

use Magento\Customer\Model\Customer;
use Magento\Customer\Model\Validator\Email;
use PHPUnit\Framework\MockObject\MockObject;
use PHPUnit\Framework\TestCase;
use Magento\Framework\TestFramework\Unit\Helper\MockCreationTrait;

class EmailTest extends TestCase
{
    use MockCreationTrait;

    private const LONG_EMAIL = 'abcdefghijklmnopqrstuvwxyz.abcdefghijklmnopqrstuvwxyz.0123456789@'
        . 'abcdefghijklmnopqrstuvwxyz.abcdefghijklmnopqrstuvwxyz.abcdefghijklmnopqrstuvwxyz.'
        . 'abcdefghijklmnopqrstuvwxyz.abcdefghijklmnopqrstuvwxyz.abcdefghijklmnopqrstuvwxyz.'
        . 'abcdefghijklmnopqrstuvwxy.com';

    /**
     * @var Email
     */
    private $validator;

    /**
     * @var Customer|MockObject
     */
    private $customerMock;

    /**
     * @inheritdoc
     */
    protected function setUp(): void
    {
        $this->validator = new Email();
        $this->customerMock = $this->createPartialMockWithReflection(
            Customer::class,
            ['getEmail']
        );
    }

    public function testValidEmailLength(): void
    {
        $this->customerMock->method('getEmail')->willReturn('customer@example.com');
        $this->assertTrue($this->validator->isValid($this->customerMock));
        $this->assertEmpty($this->validator->getMessages());
    }

    public function testInvalidEmailLength(): void
    {
        $this->customerMock->method('getEmail')->willReturn(self::LONG_EMAIL);
        $this->assertFalse($this->validator->isValid($this->customerMock));
        $this->assertEquals(
            [['email' => '"Email" uses too many characters.']],
            $this->validator->getMessages()
        );
    }
}
