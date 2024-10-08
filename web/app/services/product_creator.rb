# frozen_string_literal: true

class ProductCreator < ApplicationService
  attr_reader :count

  CREATE_PRODUCTS_MUTATION = <<~QUERY
    mutation populateProduct($input: ProductInput!) {
      productCreate(input: $input) {
        product {
          title
          id
        }
      }
    }
  QUERY

  def initialize(count:, session:)
    super()
    @count = count
    @session = session
  end

  def call
    client = ShopifyAPI::Clients::Graphql::Admin.new(session: @session)

    (1..count).each do |_i|
      response = client.query(
        query: CREATE_PRODUCTS_MUTATION,
        variables: {
          input: {
            title: random_title,
            variants: [{ price: random_price }],
          },
        }
      )

      created_product = response.body['data']['productCreate']['product']
      ShopifyAPI::Logger.info("Created Product | Title: '#{created_product['title']}' | Id: '#{created_product['id']}'")
    end
  end

  private

  def random_title
    adjective = ADJECTIVES[rand(ADJECTIVES.size)]
    noun = NOUNS[rand(NOUNS.size)]

    "#{adjective} #{noun}"
  end

  def random_price
    (100.0 + rand(1000)) / 100
  end

  ADJECTIVES = %w(
    autumn
    hidden
    bitter
    misty
    silent
    empty
    dry
    dark
    summer
    icy
    delicate
    quiet
    white
    cool
    spring
    winter
    patient
    twilight
    dawn
    crimson
    wispy
    weathered
    blue
    billowing
    broken
    cold
    damp
    falling
    frosty
    green
    long
  ).freeze

  NOUNS = %w(
    waterfall
    river
    breeze
    moon
    rain
    wind
    sea
    morning
    snow
    lake
    sunset
    pine
    shadow
    leaf
    dawn
    glitter
    forest
    hill
    cloud
    meadow
    sun
    glade
    bird
    brook
    butterfly
    bush
    dew
    dust
    field
    fire
    flower
  ).freeze
end
